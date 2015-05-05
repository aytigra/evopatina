ActivitiesConstants = require '../constants/activities_constants'
ActivitiesAPI = require '../sources/activities_api'
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
    create_response: ActivitiesConstants.ACTIVITY_CREATE_RESPONSE
    edit: ActivitiesConstants.ACTIVITY_EDIT
    cancel: ActivitiesConstants.ACTIVITY_CANCEL
    update: ActivitiesConstants.ACTIVITY_UPDATE
    update_response: ActivitiesConstants.ACTIVITY_UPDATE_RESPONSE
    save: ActivitiesConstants.ACTIVITY_SAVE
    destroy: ActivitiesConstants.ACTIVITY_DELETE

  #create empty activity in subsector with placeholder ID
  create: (subsector_id)->
    @state.activities[subsector_id] ||= {}
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

  edit: (activity)->
    @state.activities[activity.subsector_id][activity.id]['edtitng'] = true
    @state.activities[activity.subsector_id][activity.id]['name_old'] = activity.name
    @hasChanged()

  cancel: (activity)->
    if typeof activity.id == "string" && !activity.name_old
      #delete canceled and not saved yet new activity
      @destroy(activity)
    else
      activity.edtitng = false
      activity.name = activity.name_old
      @update(activity)

  update: (activity)->
    @state.activities[activity.subsector_id][activity.id] = activity
    @hasChanged()
    #put to server
    if typeof activity.id != "string"
      ActivitiesAPI.update(activity)

  update_response: (activity, ok)->
    if !ok
      @state.activities[activity.subsector_id][activity.id].edtitng = true
      @state.activities[activity.subsector_id][activity.id].have_errors = true
      @state.activities[activity.subsector_id][activity.id].errors = activity.errors
      @hasChanged()
    else
      @state.activities[activity.subsector_id][activity.id].errors = {}
      @state.activities[activity.subsector_id][activity.id].have_errors = false
      @hasChanged()

  save: (activity)->
    activity.edtitng = false
    activity.name_old = activity.name
    if typeof activity.id != "string"
      @update(activity)
    else
      #create to server, replase ID on success
      ActivitiesAPI.create(activity)
      @hasChanged()

  create_response: (activity, ok)->
    if !ok
      @state.activities[activity.subsector_id][activity.old_id].edtitng = true
      @state.activities[activity.subsector_id][activity.old_id].have_errors = true
      @state.activities[activity.subsector_id][activity.old_id].errors = activity.errors
      @hasChanged()
    else
      @state.activities[activity.subsector_id][activity.id] = @state.activities[activity.subsector_id][activity.old_id]
      @state.activities[activity.subsector_id][activity.id].id = activity.id
      @state.activities[activity.subsector_id][activity.id].errors = {}
      @state.activities[activity.subsector_id][activity.id].have_errors = false
      delete @state.activities[activity.subsector_id][activity.old_id]
      @hasChanged()

  destroy: (activity)->
    @state.activities[activity.subsector_id][activity.id] = null
    delete @state.activities[activity.subsector_id][activity.id]
    @hasChanged()
    #delete to server

module.exports = ActivitiesStore