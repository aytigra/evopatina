WeeksConstants = require '../constants/weeks_constants'

WeeksActionCreators = Marty.createActionCreators
  id: 'WeeksActionCreators'

  get_week_response: (week, ok) ->
    @dispatch WeeksConstants.WEEK_GET_RESPONSE, week, ok

  select_sector: (sector) ->
    @dispatch WeeksConstants.WEEK_SELECT_SECTOR, sector

  show_sectors: ()->
    @dispatch WeeksConstants.WEEK_SHOW_SECTORS

  show_stats: ()->
    @dispatch WeeksConstants.WEEK_SHOW_STATS

module.exports = WeeksActionCreators