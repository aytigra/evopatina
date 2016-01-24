UIConstants = require '../constants/ui_constants'

UIActionCreators = Marty.createActionCreators
  id: 'UIActionCreators'


  select_sector: (sector) ->
    @dispatch UIConstants.UI_SELECT_SECTOR, sector

  show_sectors: ()->
    @dispatch UIConstants.UI_SHOW_SECTORS

  show_stats: ()->
    @dispatch UIConstants.UI_SHOW_STATS

  set_reactor_fragments_per_day: (fragments) ->
    @dispatch UIConstants.UI_SET_REACTOR_FRAGMENTS_PER_DAY, fragments

module.exports = UIActionCreators