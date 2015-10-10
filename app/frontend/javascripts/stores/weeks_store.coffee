WeeksConstants = require '../constants/weeks_constants'
WeeksAPI = require '../sources/weeks_api'
Immutable = require 'seamless-immutable'

WeeksStore = Marty.createStore
  id: 'WeeksStore'
  displayName: 'WeeksStore'

  getInitialState: ->
    weeks: {}
    current_week: {sectors: {}}

  setInitialState: (week, ok) ->
    if ok && not _.isEmpty(week)

      #prevent nill errors with emty lists
      for key, val of week.sectors
        week.sectors[key].subsectors ||= {}
        for skey, sval of week.sectors[key].subsectors
          week.sectors[key].subsectors[skey].activities ||= {}

      @state.current_week = Immutable(week)
      @hasChanged()
    else
      alert('arrr! boat is sinking')

  handlers:
    updateWeekLapa: WeeksConstants.WEEK_LAPA_UPDATE
    setInitialState: WeeksConstants.WEEK_GET_RESPONSE

  loadWeek: (id) ->
    WeeksAPI.get_week +id

  update_subsector: (sector_id, subsector_id, params = {}) ->
    data = 
      sectors:
        "#{sector_id}":
          subsectors:
            "#{subsector_id}": params
    @state.current_week = @state.current_week.merge(data, {deep: true})
    @hasChanged()

  delete_subsector: (sector_id, subsector_id) ->
    current_week = @state.current_week.asMutable({deep: true})
    minus_count = 0
    for k, activity of current_week.sectors[sector_id].subsectors[subsector_id].activities
      minus_count += activity.count
    current_week.sectors[sector_id].subsectors[subsector_id] = null
    delete current_week.sectors[sector_id].subsectors[subsector_id]
    current_week.sectors[sector_id].progress -= minus_count
    @state.current_week = Immutable current_week
    @hasChanged()

  update_activity: (sector_id, subsector_id, activity_id, params = {}) ->
    count_change = 0
    activity_old = @get_activity sector_id, subsector_id, activity_id
    if _.has(params, 'count') && activity_old
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

  delete_activity: (sector_id, subsector_id, activity_id) ->
    current_week = @state.current_week.asMutable({deep: true})
    minus_count = current_week.sectors[sector_id].subsectors[subsector_id].activities[activity_id].count
    current_week.sectors[sector_id].subsectors[subsector_id].activities[activity_id] = null
    delete current_week.sectors[sector_id].subsectors[subsector_id].activities[activity_id]
    current_week.sectors[sector_id].progress -= minus_count
    @state.current_week = Immutable current_week
    @hasChanged()
    

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