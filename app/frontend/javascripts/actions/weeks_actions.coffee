WeeksConstants = require '../constants/weeks_constants'

WeeksActionCreators = Marty.createActionCreators
  id: 'WeeksActionCreators'

  get_week_response: (week, ok) ->
    @dispatch WeeksConstants.WEEK_GET_RESPONSE, week, ok

module.exports = WeeksActionCreators