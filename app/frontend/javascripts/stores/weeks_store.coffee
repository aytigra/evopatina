WeeksConstants = require '../constants/weeks_constants'
Immutable = require 'seamless-immutable'

WeeksStore = Marty.createStore
  id: 'WeeksStore'
  displayName: 'WeeksStore'

  getInitialState: ->
    weeks: {}
    current_week: {}

  setInitialState: (JSON)->
    if JSON && Object.keys(JSON).length
      @state.current_week = Immutable(JSON.current_week)
      @hasChanged()
    else
      alert('arrr! boat is sinking')


  handlers:
    updateWeekLapa: WeeksConstants.WEEK_LAPA_UPDATE

  updateWeekLapa: (lapa) ->
    @setState
      current_week:
        lapa: lapa

  getCurrentLapa: (sector_id) ->
    @state.current_week.lapa[sector_id]

  getCurrentWeek: ->
    @state.current_week

  getSectors: ->
     @state.current_week.sectors

module.exports = WeeksStore