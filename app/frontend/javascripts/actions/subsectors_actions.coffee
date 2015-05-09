SubsectorsConstants = require '../constants/subsectors_constants'

SubsectorsActionCreators = Marty.createActionCreators
  id: 'SubsectorsActionCreators'

  edit: (subsector) ->
    @dispatch SubsectorsConstants.SUBSECTOR_EDIT, subsector
  cancel: (subsector) ->
    @dispatch SubsectorsConstants.SUBSECTOR_CANCEL, subsector
  update: (subsector, params) ->
    @dispatch SubsectorsConstants.SUBSECTOR_UPDATE, subsector, params
  update_text: (subsector, params) ->
    @dispatch SubsectorsConstants.SUBSECTOR_UPDATE_TEXT, subsector, params
  update_response: (subsector, ok) ->
    @dispatch SubsectorsConstants.SUBSECTOR_UPDATE_RESPONSE, subsector, ok
  save: (subsector) ->
    @dispatch SubsectorsConstants.SUBSECTOR_SAVE, subsector
  destroy: (subsector) ->
    @dispatch SubsectorsConstants.SUBSECTOR_DELETE, subsector
  destroy_response: (subsector, ok) ->
    @dispatch SubsectorsConstants.SUBSECTOR_DELETE_RESPONSE, subsector, ok
  create: (sector_id) ->
    @dispatch SubsectorsConstants.SUBSECTOR_CREATE, sector_id
  create_response: (subsector, ok) ->
    @dispatch SubsectorsConstants.SUBSECTOR_CREATE_RESPONSE, subsector, ok

module.exports = SubsectorsActionCreators