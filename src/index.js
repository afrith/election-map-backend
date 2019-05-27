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

    const port = process.env.PORT || 3000
    app.listen(port, () => {winston.info(`Listening on port ${port}`)})
  })
  .catch(err => {
    console.log('Postgres error', err)
    process.exit(1)
  })