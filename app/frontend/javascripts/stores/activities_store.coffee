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
    cancel: ActivitiesConstants.ACTIVITY_CANCEL
    update: ActivitiesConstants.ACTIVITY_UPDATE
    save: ActivitiesConstants.ACTIVITY_SAVE
    destroy: ActivitiesConstants.ACTIVITY_DELETE

  edit: (activity)->
    @state.activities[activity.subsector_id][activity.id]['edtitng'] = true
    @state.activities[activity.subsector_id][activity.id]['name_old'] = activity.name
    @hasChanged()

  cancel: (activity)->
    activity.edtitng = false
    activity.name = activity.name_old
    @update(activity)

  update: (activity)->
    @state.activities[activity.subsector_id][activity.id] = activity
    @hasChanged()
    #patch to server on pauses

  save: (activity)->
    activity.edtitng = false
    activity.name_old = activity.name
    @update(activity)
    #patch to server

  destroy: (activity)->
    @state.activities[activity.subsector_id][activity.id] = null
    delete @state.activities[activity.subsector_id][activity.id]
    @hasChanged()
    #delete to server

module.exports = ActivitiesStore