import express from 'express'
import winston from 'winston'
import cors from 'cors'
import morgan from 'morgan'
import pgConnString from 'pg-connection-string'
import { Pool, types } from 'pg'

winston.add(new winston.transports.Console())

const app = express()
app.use(cors())
app.use(morgan("combined", { stream: { write: message => winston.info(message.trim()) }}))

import tilestrata from 'tilestrata'
import postgismvt from 'tilestrata-postgismvt'
import lru from 'tilestrata-lru'
var strata = tilestrata()

const pgConfig = pgConnString.parse(process.env.PG_CONNSTRING)
const pgPool = new Pool(pgConfig)
types.setTypeParser(20, parseInt)
types.setTypeParser(23, parseInt)
types.setTypeParser(1700, parseFloat)

const lyrOpts = {
  geometry: 'geom',
  type: 'poly',
  srid: 4326,
  minZoom: 0,
  maxZoom: 19,
  buffer: 10,
  resolution: 4096,
  table: 'tbl',
  fields: 'code nat_win_party nat_win_perc prov_win_party prov_win_perc nat_anc prov_anc nat_da prov_da nat_eff prov_eff nat_ifp prov_ifp nat_vfplus prov_vfplus'
}

const cache = lru({size: '128mb', ttl: 300})

pgPool.query("SELECT e.id, e.code FROM election e JOIN election_type et ON e.type_id = et.id WHERE et.name = 'General Election'")
  .then(result => {
    const structureCodes = ['vd', 'ward', 'muni', 'dist', 'prov']

    for (const row of result.rows) {
      for (const struct of structureCodes) {
        const lyr = {
          ...lyrOpts,
          table_query: `SELECT * FROM tiles.${struct} WHERE election_id = ${row.id}`
        }
        strata.layer(`${struct}_${row.code}`).route('tile.mvt')
          .use(postgismvt({
            lyr,
            pgConfig
          }))
          .use(cache)
      }
    }

    app.use(tilestrata.middleware({
      server: strata,
      prefix: '/tiles'
    }))

    const electionCodes = result.rows.map(r => r.code)

    app.get('/:election/:ballot/:level/:code', function (req, res, next) {
      const { election, ballot, level, code } = req.params
      if  ( !electionCodes.includes(election)
            || !['nat', 'prov'].includes(ballot)
            || !structureCodes.includes(level))
      {
        return res.sendStatus(404)
      }

      const results = {election, ballot, level, code}

      let q1;
      if (level === 'ward') {
        q1 = `
          SELECT ward.id, muni.name || ' Ward ' || (right(ward.code, 3)::int) as name,
            e.regpop, b.valid, b.spoilt, b.total
          FROM ward_ballot_total b
            JOIN ward_election e ON b.ward_id = e.ward_id AND b.election_id = e.election_id
            JOIN ward ON b.ward_id = ward.id
            JOIN muni ON ward.muni_id = muni.id
            JOIN election ON b.election_id = election.id
            JOIN ballot ON b.ballot_id = ballot.id
          WHERE election.code = $1::text
            AND ballot.code = $2::text
            AND ward.code = $3::text
        `
      } else {
        q1 = `
          SELECT s.id, s.name, e.regpop, b.valid, b.spoilt, b.total
          FROM ${level}_ballot_total b
            JOIN ${level}_election e ON b.${level}_id = e.${level}_id AND b.election_id = e.election_id
            JOIN ${level} s ON b.${level}_id = s.id
            JOIN election ON b.election_id = election.id
            JOIN ballot ON b.ballot_id = ballot.id
          WHERE election.code = $1::text
            AND ballot.code = $2::text
            AND s.code = $3::text
        `
      }

      pgPool.query(q1, [election, ballot, code])
        .then(qres => {
          if (qres.rows.length === 0) {
            return res.sendStatus(404)
          }
          Object.assign(results, qres.rows[0])

          return pgPool.query(`
            SELECT party.name, party.abbrev, votes
            FROM ${level}_vote v
              JOIN election ON v.election_id = election.id
              JOIN ballot ON v.ballot_id = ballot.id
              JOIN party ON v.party_id = party.id
            WHERE ${level}_id = $1::int
              AND election.code = $2::text
              AND ballot.code = $3::text
          `, [results.id, election, ballot])
        })
        .then(qres => {
          delete results.id
          results.parties = qres.rows

          res.json(results)
        })
        .catch(err => next(err))
    })

    const port = process.env.PORT || 3000
    app.listen(port, () => {winston.info(`Listening on port ${port}`)})
  })
  .catch(err => {
    console.log('Postgres error', err)
    process.exit(1)
  })