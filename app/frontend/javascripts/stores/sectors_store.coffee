SectorsConstants = require '../constants/sectors_constants'
SectorsAPI = require '../sources/sectors_api'
WeeksStore = require './weeks_store'

SectorsStore = Marty.createStore
  id: 'SectorsStore'
  displayName: 'SectorsStore'
  typingTimer: null

  get: (id) ->
    WeeksStore.get_sector id

  set: (id, params = {}) ->
    WeeksStore.update_sector id, params

  unset: (id) ->
    WeeksStore.delete_sector id

  handlers:
    create: SectorsConstants.SECTOR_CREATE
    create_response: SectorsConstants.SECTOR_CREATE_RESPONSE
    edit: SectorsConstants.SECTOR_EDIT
    cancel: SectorsConstants.SECTOR_CANCEL
    update: SectorsConstants.SECTOR_UPDATE
    update_text: SectorsConstants.SECTOR_UPDATE_TEXT
    update_response: SectorsConstants.SECTOR_UPDATE_RESPONSE
    save: SectorsConstants.SECTOR_SAVE
    destroy: SectorsConstants.SECTOR_DELETE
    destroy_response: SectorsConstants.SECTOR_DELETE_RESPONSE
    move: SectorsConstants.SECTOR_MOVE
    move_response: SectorsConstants.SECTOR_MOVE_RESPONSE

  #create empty sector in sector with placeholder ID
  create: (sector) ->
    i = 1
    while @get("new_#{i}")?
      i++
    @set("new_#{i}",
      id: 'new_' + i
      name: ''
      description: ''
      icon: ''
      color: ''
      subsectors: {}
      weeks:
        "#{WeeksStore.getCurrentWeek().id}":
          lapa: 0
          progress: 0
      editing: true
      position: 9000000
    )

  edit: (sector) ->
    @set(sector.id,
      editing: true
      name_old: sector.name
      description_old: sector.description
    )

  cancel: (sector) ->
    if typeof sector.id is "string" && !sector.name_old
      #unset canceled and not saved yet new sector
      @unset sector.id
    else
      prpams =
        editing: false
        name: sector.name_old
        description: sector.description_old
      @update(sector, prpams)

  update_text: (sector, params) ->
    @set sector.id, params
    if typeof sector.id isnt "string"
      clearTimeout @typingTimer
      callback = => @update(sector, params)
      @typingTimer = setTimeout(callback , 500)

  update: (sector, params) ->
    @set sector.id, params
    #put to server
    if typeof sector.id isnt "string"
      SectorsAPI.update @get(sector.id)

  update_response: (sector, ok) ->
    if !ok
      @set(sector.id,
        editing: true
        have_errors: true
        errors: sector.errors
      )
    else
      @set(sector.id,
        have_errors: false
        errors: {}
      )

  save: (sector) ->
    @typingTimer = null
    prpams =
      editing: false
      name_old: sector.name
      description_old: sector.description
    @update(sector, prpams)
    if typeof sector.id is "string"
      #create to server, replase ID on success
      SectorsAPI.create(sector)

  create_response: (sector, ok) ->
    if !ok
      @set(sector.old_id,
        editing: true
        have_errors: true
        errors: sector.errors
      )
    else
      new_sector = @get(sector.old_id).asMutable()
      new_sector.id = sector.id
      new_sector.have_errors = false
      new_sector.errors = {}
      @set sector.id, new_sector
      @unset sector.old_id

  destroy: (sector) ->
    @set(sector.id,
      hidden: true
    )
    #delete to server
    if typeof sector.id isnt "string"
      SectorsAPI.destroy(sector)

  destroy_response: (sector, ok) ->
    if !ok
      @set(sector.id,
        hidden: false
        have_errors: true
        errors: sector.errors
      )
    else
      @unset sector.id

  move: (sector, to) ->
    if to in ['up', 'down']
      WeeksStore.move_sector sector.id, to
      SectorsAPI.move(sector, to)

  move_response: (sector, ok) ->

module.exports = SectorsStore