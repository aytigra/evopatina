WeeksConstants = require '../constants/weeks_constants'
#WeeksQueries = require '../queries/weeks_queries'

WeeksStore = Marty.createStore
  id: 'WeeksStore'
  displayName: 'WeeksStore'

  getInitialState: ->
    current_week:
      id: 0
      progress: {}
      lapa: {}
      date: ''

  setInitialState: (data)->
    @setState data

  handlers:
    updateWeekLapa: WeeksConstants.WEEK_LAPA_UPDATE

  updateWeekLapa: (lapa) ->
    @setState
      current_week:
        lapa: lapa


module.exports = WeeksStore