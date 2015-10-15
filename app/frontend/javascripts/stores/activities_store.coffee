ActivitiesConstants = require '../constants/activities_constants'
ActivitiesAPI = require '../sources/activities_api'
WeeksStore = require './weeks_store'

ActivitiesStore = Marty.createStore
  id: 'ActivitiesStore'
  displayName: 'ActivitiesStore'
  typingTimer: null

  getInitialState: ->
    activities: {}

  setInitialState: (data) ->
    @setState
      activities: data

  get: (sector_id, subsector_id, id) ->
    WeeksStore.get_activity sector_id, subsector_id, id

  set: (sector_id, subsector_id, id, params = {}) ->
    WeeksStore.update_activity sector_id, subsector_id, id, params



  unset: (sector_id, subsector_id, id) ->
    WeeksStore.delete_activity sector_id, subsector_id, id

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
    i = 1
    while @get(subsector.sector_id, subsector.id, "new_#{i}")?
      i++
    @set(subsector.sector_id, subsector.id,"new_#{i}",
      id: 'new_' + i
      subsector_id: subsector.id
      name: ''
      description: ''
      editing: true
      editing_count: false
      count: 0
      hidden: false
      sector_id: subsector.sector_id
    )
    @hasChanged()

  edit: (activity) ->
    @set(activity.sector_id, activity.subsector_id, activity.id,
      editing: true
      name_old: activity.name
      description_old: activity.description
    )

  edit_count: (activity) ->
    @set(activity.sector_id, activity.subsector_id, activity.id,
      editing_count: true
    )

  cancel: (activity) ->
    if typeof activity.id is "string" && !activity.name_old
      #unset canceled and not saved yet new activity
      @unset activity.sector_id, activity.subsector_id, activity.id
    else if activity.editing
      params =
        editing: false
        editing_count: false
        name: activity.name_old
        description: activity.description_old
      @update(activity, params)
    else if activity.editing_count
      @set(activity.sector_id, activity.subsector_id, activity.id,
        editing_count: false
      )

  update_text: (activity, params) ->
    @set activity.sector_id, activity.subsector_id, activity.id, params
    clearTimeout @typingTimer
    callback = => @update(activity, params)
    @typingTimer = setTimeout(callback , 500)

  update: (activity, params) ->
    @set activity.sector_id, activity.subsector_id, activity.id, params
    #put to server
    if typeof activity.id isnt "string"
      ActivitiesAPI.update @get(activity.sector_id, activity.subsector_id, activity.id)

  update_response: (activity, ok) ->
    if !ok
      @set(activity.sector_id, activity.subsector_id, activity.id,
        editing: true
        hidden: false
        have_errors: true
        errors: activity.errors
      )
    else
      @set(activity.sector_id, activity.subsector_id, activity.id,
        have_errors: false
        errors: {}
      )

  update_count: (activity, params) ->
    params['week_id'] = WeeksStore.getCurrentWeek().id
    @set activity.sector_id, activity.subsector_id, activity.id, params
    ActivitiesAPI.update_count @get(activity.sector_id, activity.subsector_id, activity.id)

  update_count_response: (activity, ok) ->
    if !ok
      @set(activity.sector_id, activity.subsector_id, activity.id,
        editing_count: true
        hidden: false
        have_errors: true
        errors: activity.errors
      )
    else
      @set(activity.sector_id, activity.subsector_id, activity.id,
        have_errors: false
        errors: {}
      )

  save: (activity) ->
    params =
      editing: false
      name_old: activity.name
      description_old: activity.description
    @update(activity, params)
    if typeof activity.id is "string"
      #create to server, replase ID on success
      ActivitiesAPI.create(activity)

  create_response: (activity, ok) ->
    if !ok
      @set(activity.sector_id, activity.subsector_id, activity.old_id,
        editing: true
        have_errors: true
        errors: activity.errors
      )
    else
      new_activity = @get(activity.sector_id, activity.subsector_id, activity.old_id).asMutable()
      new_activity.id = activity.id
      new_activity.have_errors = false
      new_activity.errors = {}
      @set activity.sector_id, activity.subsector_id, activity.id, new_activity
      @unset activity.sector_id, activity.subsector_id, activity.old_id

  destroy: (activity) ->
    @set(activity.sector_id, activity.subsector_id, activity.id,
      hidden: true
    )
    #delete to server
    if typeof activity.id isnt "string"
      ActivitiesAPI.destroy(activity)

  destroy_response: (activity, ok) ->
    if !ok
      @set(activity.sector_id, activity.subsector_id, activity.id,
        hidden: false
        have_errors: true
        errors: activity.errors
      )
    else
      @unset activity.sector_id, activity.subsector_id, activity.id

  move: (activity, to) ->
    if to in ['up', 'down']
      WeeksStore.move_activity activity.sector_id, activity.subsector_id, activity.id, to
      ActivitiesAPI.move(activity, to)
    if to is 'subsector'
      select_subsector(activity, WeeksStore.getSectors())
        .then (response) =>
          console.log response

  move_response: (activity, ok) ->


module.exports = ActivitiesStore