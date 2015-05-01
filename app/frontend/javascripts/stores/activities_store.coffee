ActivitiesConstants = require '../constants/activities_constants'
#ActivitiesQueries = require '../queries/activities_queries'

ActivitiesStore = Marty.createStore
  id: 'ActivitiesStore'
  displayName: 'ActivitiesStore'

  getInitialState: ->
    activities: {}

  setInitialState: (data)->
    @setState
      activities: data




module.exports = ActivitiesStore