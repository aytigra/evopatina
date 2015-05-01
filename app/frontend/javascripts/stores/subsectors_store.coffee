SubsectorsConstants = require '../constants/subsectors_constants'
#SubsectorsQueries = require '../queries/subsectors_queries'

SubsectorsStore = Marty.createStore
  id: 'SubsectorsStore'
  displayName: 'SubsectorsStore'

  getInitialState: ->
    subsectors: {}

  setInitialState: (data)->
    @setState
      subsectors: data




module.exports = SubsectorsStore