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

  setActivity: (subsector_id, id, params = {}) ->
    for key, val of params
      @state.activities[subsector_id][id][key] = val

  unsetActivity: (subsector_id, id) ->
    @state.activities[subsector_id][id] = null
    delete @state.activities[subsector_id][id]

  handlers:
    create: ActivitiesConstants.ACTIVITY_CREATE
    create_response: ActivitiesConstants.ACTIVITY_CREATE_RESPONSE
    edit: ActivitiesConstants.ACTIVITY_EDIT
    cancel: ActivitiesConstants.ACTIVITY_CANCEL
    update: ActivitiesConstants.ACTIVITY_UPDATE
    update_response: ActivitiesConstants.ACTIVITY_UPDATE_RESPONSE
    save: ActivitiesConstants.ACTIVITY_SAVE
    destroy: ActivitiesConstants.ACTIVITY_DELETE
    destroy_response: ActivitiesConstants.ACTIVITY_DELETE_RESPONSE

  #create empty activity in subsector with placeholder ID
  create: (subsector_id)->
    @state.activities[subsector_id] ||= {}
    i = 1
    while @state.activities[subsector_id]["new_#{i}"]?
      i++
    @state.activities[subsector_id]["new_#{i}"] =  
      id: 'new_' + i
      subsector_id: subsector_id
      name: ''
      description: ''
      edtitng: true
    @hasChanged()

  edit: (activity)->
    @setActivity(activity.subsector_id, activity.id,
      edtitng: true
      name_old: activity.name
    )
    @hasChanged()

  cancel: (activity)->
    if typeof activity.id is "string" && !activity.name_old
      #unset canceled and not saved yet new activity
      @unsetActivity(activity.subsector_id, activity.id)
      @hasChanged()
    else
      activity.edtitng = false
      activity.name = activity.name_old
      @update(activity)

  update: (activity)->
    @setActivity(activity.subsector_id, activity.id,
      name: activity.name
    )
    @hasChanged()
    #put to server
    if typeof activity.id isnt "string"
      ActivitiesAPI.update(activity)

  update_response: (activity, ok)->
    if !ok
      @setActivity(activity.subsector_id, activity.id,
        edtitng: true
        have_errors: true
        errors: activity.errors
      )
    else
      @setActivity(activity.subsector_id, activity.id,
        have_errors: false
        errors: {}
      )
    @hasChanged()

  save: (activity)->
    activity.edtitng = false
    activity.name_old = activity.name
    if typeof activity.id isnt "string"
      @update(activity)
    else
      #create to server, replase ID on success
      ActivitiesAPI.create(activity)
      @hasChanged()

  create_response: (activity, ok)->
    if !ok
      @setActivity(activity.subsector_id, activity.old_id,
        edtitng: true
        have_errors: true
        errors: activity.errors
      )
    else
      @state.activities[activity.subsector_id][activity.id] = @state.activities[activity.subsector_id][activity.old_id]
      @setActivity(activity.subsector_id, activity.id,
        id: activity.id
        have_errors: false
        errors: {}
      )
      @unsetActivity(activity.subsector_id, activity.old_id)
    @hasChanged()

  destroy: (activity)->
    @setActivity(activity.subsector_id, activity.id,
      hidden: true
    )
    @hasChanged()
    #delete to server
    if typeof activity.id isnt "string"
      ActivitiesAPI.destroy(activity)

  destroy_response: (activity, ok)->
    if !ok
      @setActivity(activity.subsector_id, activity.id,
        hidden: false
        have_errors: true
        errors: ['server error: can not delete']
      )
    else
      @unsetActivity(activity.subsector_id, activity.id)
    @hasChanged()

module.exports = ActivitiesStore