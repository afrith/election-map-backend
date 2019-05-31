This is the backend that serves map tiles and data for the election map which
is deployed at https://elections.adrianfrith.com/. The repository for the
frontend is at https://github.com/afrith/election-map-frontend.

## Service

The service provides Mapbox Vector Tiles (MVTs) for five levels of electoral geography: province, district council, municipality, ward, and voting district. The tiles include selected data points from the election results for ease of rendering. The tiles are provided at URLs of the form `/tiles/{level}_{election}/{z}/{x}/{y}/tile.mvt`, where:

* `{level}` is one of "prov", "dist", "muni", "ward" or "vd", corresponding to the five levels of electoral geography listed above.
* `{election}` is be one of "npe2004", "npe2009", "npe2014" or "npe2019".

The service also provides an endpoint to fetch full details of election results for any electoral geography as a JSON document. This endpoint is provided at URLs of the form `/{election}/{ballot}/{level}/{code}`, where:

* `{level}` and `{election}` are as described above.
* `{ballot}` is either "nat" or "prov", for the national and provincial ballot results respectively.
* `{code}` is the unique code identifying a geography, which can also be found in the `code` property of objects in the  MVTs.

## Tech stack

* Data store
  * PostgreSQL
  * PostGIS
* Service
  * Node.js
  * Express.js
  * [TileStrata](https://github.com/naturalatlas/tilestrata)
  * `tilestrata-postgismvt` slightly modified (see [repo](https://github.com/afrith/tilestrata-postgismvt))