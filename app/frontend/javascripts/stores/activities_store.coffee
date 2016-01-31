ActivitiesConstants = require '../constants/activities_constants'
ActivitiesAPI = require '../sources/activities_api'

ActivitiesStore = Marty.createStore
  id: 'ActivitiesStore'
  displayName: 'ActivitiesStore'
  typingTimer: null

  get: (id) ->
    AppStore.get_activity id

  set: (id, params = {}) ->
    AppStore.update_activity id, params

  unset: (id) ->
    AppStore.delete_activity id

  handlers:
    create: ActivitiesConstants.ACTIVITY_CREATE
    create_response: ActivitiesConstants.ACTIVITY_CREATE_RESPONSE
    edit: ActivitiesConstants.ACTIVITY_EDIT
    edit_count: ActivitiesConstants.ACTIVITY_EDIT_COUNT
    cancel: ActivitiesConstants.ACTIVITY_CANCEL
    update: ActivitiesConstants.ACTIVITY_UPDATE
    update_text: ActivitiesConstants.ACTIVITY_UPDATE_TEXT
    update_response: ActivitiesConstants.ACTIVITY_UPDATE_RESPONSE
    update_count: ActivitiesConstants.ACTIVITY_UPDATE_COUNT
    update_count_response: ActivitiesConstants.ACTIVITY_UPDATE_COUNT_RESPONSE
    save: ActivitiesConstants.ACTIVITY_SAVE
    destroy: ActivitiesConstants.ACTIVITY_DELETE
    destroy_response: ActivitiesConstants.ACTIVITY_DELETE_RESPONSE
    move: ActivitiesConstants.ACTIVITY_MOVE
    move_response: ActivitiesConstants.ACTIVITY_MOVE_RESPONSE

  #create empty activity in subsector with placeholder ID
  create: (subsector) ->
    AppStore.new_activity(subsector.id)

  edit: (activity) ->
    @set(activity.id,
      editing: true
      name_old: activity.name
      description_old: activity.description
    )

  edit_count: (activity) ->
    @set(activity.id,
      editing_count: true
    )

  cancel: (activity) ->
    if typeof activity.id is "string" && !activity.name_old
      #unset new empty cancelled activity
      @unset activity.id
    else if activity.editing
      @set activity.id,
        editing: false
        editing_count: false
        name: activity.name_old
        description: activity.description_old

      if activity.name_old != activity.name || activity.description_old != activity.description
        ActivitiesAPI.update @get(activity.id)
    else if activity.editing_count
      @set activity.id,
        editing_count: false

  update_text: (activity, params) ->
    @set activity.id, params
    if typeof activity.id isnt "string"
      clearTimeout @typingTimer
      callback = => ActivitiesAPI.update @get(activity.id)
      @typingTimer = setTimeout(callback , 500)

  update: (activity, params) ->
    @set activity.id, params
    #put to server
    if typeof activity.id isnt "string"
      ActivitiesAPI.update @get(activity.id)

  update_response: (activity, ok) ->
    if !ok
      @set(activity.id,
        editing: true
        hidden: false
        have_errors: true
        errors: activity.errors
      )
    else
      @set(activity.id,
        have_errors: false
        errors: {}
      )

  update_count: (activity, params) ->
    @set activity.id, params

    ActivitiesAPI.update_count @get(activity.id), AppStore.get_day().id

  update_count_response: (activity, ok) ->
    if !ok
      @set(activity.id,
        editing_count: true
        hidden: false
        have_errors: true
        errors: activity.errors
      )
    else
      @set(activity.id,
        have_errors: false
        errors: {}
      )

  save: (activity) ->
    @typingTimer = null
    @update activity,
      editing: false
      name_old: activity.name
      description_old: activity.description

    if typeof activity.id is "string"
      #create to server, replase ID on success
      ActivitiesAPI.create(activity)

  create_response: (activity, ok) ->
    if !ok
      @set(activity.old_id,
        editing: true
        have_errors: true
        errors: activity.errors
      )
    else
      AppStore.update_activity_id(activity.old_id, activity.id)

  destroy: (activity) ->
    @set(activity.id,
      hidden: true
    )
    #delete to server
    if typeof activity.id isnt "string"
      ActivitiesAPI.destroy(activity)

  destroy_response: (activity, ok) ->
    if !ok
      @set(activity.id,
        hidden: false
        have_errors: true
        errors: activity.errors
      )
    else
      @unset activity.id

  move: (activity, to) ->
    if to in ['up', 'down']
      AppStore.move_activity activity.id, to
      ActivitiesAPI.move(activity, to)
    if to is 'subsector'
      select_subsector(activity)
        .then (dest) =>
          AppStore.move_activity activity.id, to, dest
          ActivitiesAPI.move({id: activity.id, subsector_id: dest.subsector_id}, 'subsector')


  move_response: (activity, ok) ->


module.exports = ActivitiesStore