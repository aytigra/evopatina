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

module.exports = WeeksActionCreators