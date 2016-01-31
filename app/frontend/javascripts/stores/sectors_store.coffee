SectorsConstants = require '../constants/sectors_constants'
SectorsAPI = require '../sources/sectors_api'

SectorsStore = Marty.createStore
  id: 'SectorsStore'
  displayName: 'SectorsStore'
  typingTimer: null

  get: (id) ->
    AppStore.get_sector id

  set: (id, params = {}) ->
    AppStore.update_sector id, params

  unset: (id) ->
    AppStore.delete_sector id

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
    AppStore.new_sector()

  edit: (sector) ->
    @set(sector.id,
      editing: true
      name_old: sector.name
      description_old: sector.description
    )

  cancel: (sector) ->
    if typeof sector.id is "string" && !sector.name_old
      #unset new empty cancelled sector
      @unset sector.id
    else
      @set sector.id,
        editing: false
        name: sector.name_old
        description: sector.description_old

      if sector.name_old != sector.name || sector.description_old != sector.description
        SectorsAPI.update @get(sector.id)

  update_text: (sector, params) ->
    @set sector.id, params
    if typeof sector.id isnt "string"
      clearTimeout @typingTimer
      callback = => SectorsAPI.update @get(sector.id)
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
    @update sector,
      editing: false
      name_old: sector.name
      description_old: sector.description

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
      AppStore.update_sector_id sector.old_id, sector.id

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
      AppStore.move_sector sector.id, to
      SectorsAPI.move(sector, to)

  move_response: (sector, ok) ->

module.exports = SectorsStore