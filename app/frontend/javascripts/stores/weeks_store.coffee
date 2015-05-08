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

  getCurrentLapa: (sector_id) ->
    @state.current_week.lapa[sector_id]

  getCurrentProgress: (sector_id) ->
    @state.current_week.progress[sector_id]

  setCurrentProgress: (sector_id, count_change) ->
    @state.current_week.progress[sector_id] = @state.current_week.progress[sector_id] + count_change
    @hasChanged()

  getCurrentWeek: ->
    @state.current_week

module.exports = WeeksStore