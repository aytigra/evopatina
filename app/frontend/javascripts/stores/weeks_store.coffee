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
      #@hasChanged()
    else
      alert('arrr! boat is sinking')

  update_subsector: (sector_id, subsector_id, params = {}) ->
    data = 
      sectors:
        "#{sector_id}":
          subsectors:
            "#{subsector_id}": params
    @state.current_week = @state.current_week.merge(data, {deep: true})
    @hasChanged()

  update_activity: (sector_id, subsector_id, activity_id, params = {}) ->
    count_change = 0
    if params.hasOwnProperty('count')
      activity_old = @get_activity sector_id, subsector_id, activity_id
      count_change = params.count - activity_old.count
    progress = @get_sector(sector_id).progress + count_change

    data = 
      sectors:
        "#{sector_id}":
          progress: progress
          subsectors:
            "#{subsector_id}":
              activities:
                "#{activity_id}": params
              
    @state.current_week = @state.current_week.merge(data, {deep: true})

    @hasChanged()


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

  get_sector: (sector_id) ->
    @state.current_week.sectors[sector_id]

  get_subsector: (sector_id, subsector_id) ->
    @state.current_week.sectors[sector_id].subsectors[subsector_id]

  get_activity: (sector_id, subsector_id, activity_id) ->
    @state.current_week.sectors[sector_id].subsectors[subsector_id].activities[activity_id]

module.exports = WeeksStore