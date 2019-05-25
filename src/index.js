import express from 'express'
import winston from 'winston'
import cors from 'cors'
import morgan from 'morgan'
import pgConnString from 'pg-connection-string'

winston.add(new winston.transports.Console())

const app = express()
app.use(cors())
app.use(morgan("combined", { stream: { write: message => winston.info(message.trim()) }}))

import tilestrata from 'tilestrata'
import postgismvt from 'tilestrata-postgismvt'
import lru from 'tilestrata-lru'
var strata = tilestrata()

const pgConfig = pgConnString.parse(process.env.PG_CONNSTRING)

const lyrOpts = {
  geometry: 'geom',
  type: 'poly',
  srid: 4326,
  minZoom: 0,
  maxZoom: 19,
  buffer: 10,
  resolution: 4096
}

const cache = lru({size: '128mb', ttl: 300})

strata.layer('vd_2019').route('tile.mvt')
  .use(postgismvt({
    lyr: {
      ...lyrOpts,
      table: 'vdl',
      table_query: 'SELECT * FROM tiles.vd WHERE election_id = 8',
      fields: 'code nat_win_party nat_win_perc prov_win_party prov_win_perc'
    },
    pgConfig
  }))
  .use(cache)

app.use(tilestrata.middleware({
  server: strata,
  prefix: '/'
}))

const port = process.env.PORT || 3000
app.listen(port, () => {winston.info(`Listening on port ${port}`)})