SubsectorsConstants = require '../constants/subsectors_constants'
SubsectorsAPI = require '../sources/subsectors_api'
WeeksStore = require './weeks_store'

SubsectorsStore = Marty.createStore
  id: 'SubsectorsStore'
  displayName: 'SubsectorsStore'
  typingTimer: null

  getInitialState: ->
    subsectors: {}

  setInitialState: (data) ->
    @setState
      subsectors: data

  get: (sector_id, id) ->
    WeeksStore.get_subsector sector_id, id

  set: (sector_id, id, params = {}) ->
    WeeksStore.update_subsector sector_id, id, params

  unset: (sector_id, id) ->
    WeeksStore.delete_subsector sector_id, id

  handlers:
    create: SubsectorsConstants.SUBSECTOR_CREATE
    create_response: SubsectorsConstants.SUBSECTOR_CREATE_RESPONSE
    edit: SubsectorsConstants.SUBSECTOR_EDIT
    cancel: SubsectorsConstants.SUBSECTOR_CANCEL
    update: SubsectorsConstants.SUBSECTOR_UPDATE
    update_text: SubsectorsConstants.SUBSECTOR_UPDATE_TEXT
    update_response: SubsectorsConstants.SUBSECTOR_UPDATE_RESPONSE
    save: SubsectorsConstants.SUBSECTOR_SAVE
    destroy: SubsectorsConstants.SUBSECTOR_DELETE
    destroy_response: SubsectorsConstants.SUBSECTOR_DELETE_RESPONSE
    move: SubsectorsConstants.SUBSECTOR_MOVE
    move_response: SubsectorsConstants.SUBSECTOR_MOVE_RESPONSE

  #create empty subsector in sector with placeholder ID
  create: (sector) ->
    i = 1
    while @get(sector.id, "new_#{i}")?
      i++
    @set(sector.id, "new_#{i}",
      id: 'new_' + i
      sector_id: sector.id
      name: ''
      description: ''
      activities: {}
      editing: true
      show_hidden: false
    )

  edit: (subsector) ->
    @set(subsector.sector_id, subsector.id,
      editing: true
      name_old: subsector.name
      description_old: subsector.description
    )

  cancel: (subsector) ->
    if typeof subsector.id is "string" && !subsector.name_old
      #unset canceled and not saved yet new subsector
      @unset subsector.sector_id, subsector.id
    else
      prpams =
        editing: false
        name: subsector.name_old
        description: subsector.description_old
      @update(subsector, prpams)

  update_text: (subsector, params) ->
    @set subsector.sector_id, subsector.id, params
    clearTimeout @typingTimer
    callback = => @update(subsector, params)
    @typingTimer = setTimeout(callback , 500)

  update: (subsector, params) ->
    @set subsector.sector_id, subsector.id, params
    #put to server
    if typeof subsector.id isnt "string"
      SubsectorsAPI.update @get(subsector.sector_id, subsector.id)

  update_response: (subsector, ok) ->
    if !ok
      @set(subsector.sector_id, subsector.id,
        editing: true
        have_errors: true
        errors: subsector.errors
      )
    else
      @set(subsector.sector_id, subsector.id,
        have_errors: false
        errors: {}
      )

  save: (subsector) ->
    prpams =
      editing: false
      name_old: subsector.name
      description_old: subsector.description
    @update(subsector, prpams)
    if typeof subsector.id is "string"
      #create to server, replase ID on success
      SubsectorsAPI.create(subsector)

  create_response: (subsector, ok) ->
    if !ok
      @set(subsector.sector_id, subsector.old_id,
        editing: true
        have_errors: true
        errors: subsector.errors
      )
    else
      new_subsector = @get(subsector.sector_id, subsector.old_id).asMutable()
      new_subsector.id = subsector.id
      new_subsector.have_errors = false
      new_subsector.errors = {}
      @set subsector.sector_id, subsector.id, new_subsector
      @unset subsector.sector_id, subsector.old_id

  destroy: (subsector) ->
    @set(subsector.sector_id, subsector.id,
      hidden: true
    )
    #delete to server
    if typeof subsector.id isnt "string"
      SubsectorsAPI.destroy(subsector)

  destroy_response: (subsector, ok) ->
    if !ok
      @set(subsector.sector_id, subsector.id,
        hidden: false
        have_errors: true
        errors: subsector.errors
      )
    else
      @unset subsector.sector_id, subsector.id

  move: (subsector, to) ->
    if to in ['up', 'down']
      WeeksStore.move_subsector subsector.sector_id, subsector.id, to
      SubsectorsAPI.move(subsector, to)
    if to is 'sector'
      select_sector(subsector, WeeksStore.getSectors())
        .then (dest) =>
          new_subsector = subsector.merge(
            sector_id: dest.sector_id
            editing: false
          )
          @set dest.sector_id, subsector.id, new_subsector
          @unset subsector.sector_id, subsector.id
          SubsectorsAPI.move(new_subsector, 'sector')


  move_response: (subsector, ok) ->

module.exports = SubsectorsStore