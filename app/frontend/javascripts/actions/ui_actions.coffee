UIConstants = require '../constants/ui_constants'

UIActionCreators = Marty.createActionCreators
  id: 'UIActionCreators'


  select_sector: (sector) ->
    @dispatch UIConstants.UI_SELECT_SECTOR, sector

  show_sectors: ()->
    @dispatch UIConstants.UI_SHOW_SECTORS

  show_stats: ()->
    @dispatch UIConstants.UI_SHOW_STATS

module.exports = UIActionCreators