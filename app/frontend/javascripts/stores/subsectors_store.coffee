SubsectorsConstants = require '../constants/subsectors_constants'
SubsectorsAPI = require '../sources/subsectors_api'
#SubsectorsQueries = require '../queries/subsectors_queries'
ActivitiesStore = require('./activities_store');

SubsectorsStore = Marty.createStore
  id: 'SubsectorsStore'
  displayName: 'SubsectorsStore'

  getInitialState: ->
    subsectors: {}

  setInitialState: (data) ->
    @setState
      subsectors: data

  getSubsectors: (sector_id) ->
    result = {}
    for id, subsector of @state.subsectors[sector_id]
      subsector['activities'] = ActivitiesStore.getActivities id
      result[id] = subsector
    result

  setSubsector: (sector_id, id, params = {}) ->
    for key, val of params
      @state.subsectors[sector_id][id][key] = val

  unsetSubsector: (sector_id, id) ->
    @state.subsectors[sector_id][id] = null
    delete @state.subsectors[sector_id][id]

  handlers:
    create: SubsectorsConstants.SUBSECTOR_CREATE
    create_response: SubsectorsConstants.SUBSECTOR_CREATE_RESPONSE
    edit: SubsectorsConstants.SUBSECTOR_EDIT
    cancel: SubsectorsConstants.SUBSECTOR_CANCEL
    update: SubsectorsConstants.SUBSECTOR_UPDATE
    update_response: SubsectorsConstants.SUBSECTOR_UPDATE_RESPONSE
    save: SubsectorsConstants.SUBSECTOR_SAVE
    destroy: SubsectorsConstants.SUBSECTOR_DELETE
    destroy_response: SubsectorsConstants.SUBSECTOR_DELETE_RESPONSE

  #create empty subsector in sector with placeholder ID
  create: (sector_id) ->
    @state.subsectors[sector_id] ||= {}
    i = 1
    while @state.subsectors[sector_id]["new_#{i}"]?
      i++
    @state.subsectors[sector_id]["new_#{i}"] =  
      id: 'new_' + i
      sector_id: sector_id
      name: ''
      description: ''
      edtitng: true
    @hasChanged()

  edit: (subsector) ->
    @setSubsector(subsector.sector_id, subsector.id,
      edtitng: true
      name_old: subsector.name
    )
    @hasChanged()

  cancel: (subsector) ->
    if typeof subsector.id is "string" && !subsector.name_old
      #unset canceled and not saved yet new subsector
      @unsetSubsector(subsector.sector_id, subsector.id)
      @hasChanged()
    else
      subsector.edtitng = false
      subsector.name = subsector.name_old
      @update(subsector)

  update: (subsector) ->
    @setSubsector(subsector.sector_id, subsector.id,
      name: subsector.name
    )
    @hasChanged()
    #put to server
    if typeof subsector.id isnt "string"
      SubsectorsAPI.update(subsector)

  update_response: (subsector, ok) ->
    if !ok
      @setSubsector(subsector.sector_id, subsector.id,
        edtitng: true
        have_errors: true
        errors: subsector.errors
      )
    else
      @setSubsector(subsector.sector_id, subsector.id,
        have_errors: false
        errors: {}
      )
    @hasChanged()

  save: (subsector) ->
    subsector.edtitng = false
    subsector.name_old = subsector.name
    if typeof subsector.id isnt "string"
      @update(subsector)
    else
      #create to server, replase ID on success
      SubsectorsAPI.create(subsector)
      @hasChanged()

  create_response: (subsector, ok) ->
    if !ok
      @setSubsector(subsector.sector_id, subsector.old_id,
        edtitng: true
        have_errors: true
        errors: subsector.errors
      )
    else
      @state.subsectors[subsector.sector_id][subsector.id] = @state.subsectors[subsector.sector_id][subsector.old_id]
      @setSubsector(subsector.sector_id, subsector.id,
        id: subsector.id
        have_errors: false
        errors: {}
      )
      @unsetSubsector(subsector.sector_id, subsector.old_id)
    @hasChanged()

  destroy: (subsector) ->
    @setSubsector(subsector.sector_id, subsector.id,
      hidden: true
    )
    @hasChanged()
    #delete to server
    if typeof subsector.id isnt "string"
      SubsectorsAPI.destroy(subsector)

  destroy_response: (subsector, ok) ->
    if !ok
      @setSubsector(subsector.sector_id, subsector.id,
        hidden: false
        have_errors: true
        errors: ['server error: can not delete']
      )
    else
      @unsetSubsector(subsector.sector_id, subsector.id)
    @hasChanged()

module.exports = SubsectorsStore