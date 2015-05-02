ActivitiesConstants = require '../constants/activities_constants'
#ActivitiesQueries = require '../queries/activities_queries'

ActivitiesStore = Marty.createStore
  id: 'ActivitiesStore'
  displayName: 'ActivitiesStore'

  getInitialState: ->
    activities: {}

  setInitialState: (data) ->
    @setState
      activities: data

  getActivities: (subsector_id) ->
      @state.activities[subsector_id]

  handlers:
    edit: ActivitiesConstants.ACTIVITY_EDIT

  edit: (activity)->
    @state.activities[activity.subsector_id][activity.id]['edtitng'] = true
    @hasChanged()

module.exports = ActivitiesStore