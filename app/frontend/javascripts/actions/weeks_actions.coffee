WeeksConstants = require '../constants/weeks_constants'

WeeksActionCreators = Marty.createActionCreators
  id: 'WeeksActionCreators'

  get_week_response: (week, ok) ->
    @dispatch WeeksConstants.WEEK_GET_RESPONSE, week, ok

  select_sector: (sector) ->
    @dispatch WeeksConstants.WEEK_SELECT_SECTOR, sector

  edit_lapa: (week)->
    @dispatch WeeksConstants.WEEK_EDIT_LAPA, week

  update_lapa: (lapa)->
    @dispatch WeeksConstants.WEEK_LAPA_UPDATE, lapa

  show_sectors: (lapa)->
    @dispatch WeeksConstants.WEEK_SHOW_SECTORS

  show_stats: (lapa)->
    @dispatch WeeksConstants.WEEK_SHOW_STATS

module.exports = WeeksActionCreators