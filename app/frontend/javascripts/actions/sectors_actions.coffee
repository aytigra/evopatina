SectorsConstants = require '../constants/sectors_constants'

SectorsActionCreators = Marty.createActionCreators
  id: 'SectorsActionCreators'

  edit: (sector) ->
    @dispatch SectorsConstants.SECTOR_EDIT, sector
  cancel: (sector) ->
    @dispatch SectorsConstants.SECTOR_CANCEL, sector
  update: (sector, params) ->
    @dispatch SectorsConstants.SECTOR_UPDATE, sector, params
  update_text: (sector, params) ->
    @dispatch SectorsConstants.SECTOR_UPDATE_TEXT, sector, params
  update_response: (sector, ok) ->
    @dispatch SectorsConstants.SECTOR_UPDATE_RESPONSE, sector, ok
  save: (sector) ->
    @dispatch SectorsConstants.SECTOR_SAVE, sector
  destroy: (sector) ->
    @dispatch SectorsConstants.SECTOR_DELETE, sector
  destroy_response: (sector, ok) ->
    @dispatch SectorsConstants.SECTOR_DELETE_RESPONSE, sector, ok
  create: (sector) ->
    @dispatch SectorsConstants.SECTOR_CREATE, sector
  create_response: (sector, ok) ->
    @dispatch SectorsConstants.SECTOR_CREATE_RESPONSE, sector, ok
  move: (sector, to) ->
    @dispatch SectorsConstants.SECTOR_MOVE, sector, to
  move_response: (sector, ok) ->
    @dispatch SectorsConstants.SECTOR_MOVE_RESPONSE, sector, ok

module.exports = SectorsActionCreators