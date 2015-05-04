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
      @state.activities[subsector_id] || {}

  handlers:
    create: ActivitiesConstants.ACTIVITY_CREATE
    edit: ActivitiesConstants.ACTIVITY_EDIT
    cancel: ActivitiesConstants.ACTIVITY_CANCEL
    update: ActivitiesConstants.ACTIVITY_UPDATE
    save: ActivitiesConstants.ACTIVITY_SAVE
    destroy: ActivitiesConstants.ACTIVITY_DELETE

  create: (subsector_id)->
    @state.activities[subsector_id] ||= {}
    # optimistic create with placeholder ID 
    i = 1
    while @state.activities[subsector_id]['new_' + i]?
      i++ 
    @state.activities[subsector_id]['new_' + i] = 
      id: 'new_' + i
      subsector_id: subsector_id
      name: ''
      description: ''
      edtitng: true
    @hasChanged()
    #create to server, replase ID on success

  edit: (activity)->
    @state.activities[activity.subsector_id][activity.id]['edtitng'] = true
    @state.activities[activity.subsector_id][activity.id]['name_old'] = activity.name
    @hasChanged()

  cancel: (activity)->
    #delete canceled and not saved yet new activity
    if activity.id.indexOf('new') == 0 && !activity.name_old?
      @destroy(activity)
    else
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