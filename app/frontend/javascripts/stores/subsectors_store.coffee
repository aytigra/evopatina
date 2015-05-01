SubsectorsConstants = require '../constants/subsectors_constants'
#SubsectorsQueries = require '../queries/subsectors_queries'
ActivitiesStore = require('./activities_store');

SubsectorsStore = Marty.createStore
  id: 'SubsectorsStore'
  displayName: 'SubsectorsStore'

  getInitialState: ->
    subsectors: {}

  setInitialState: (data) ->
    @setState
      subsectors: data

  getSubsectors: (sector_id) ->
    result = {}
    for id, subsector of @state.subsectors[sector_id]
      subsector['activities'] = ActivitiesStore.getActivities id
      result[id] = subsector
    result


module.exports = SubsectorsStore