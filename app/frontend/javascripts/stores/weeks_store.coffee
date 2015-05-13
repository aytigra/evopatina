WeeksConstants = require '../constants/weeks_constants'
Immutable = require 'seamless-immutable'

WeeksStore = Marty.createStore
  id: 'WeeksStore'
  displayName: 'WeeksStore'

  getInitialState: ->
    weeks: {}
    current_week: {}

  setInitialState: (JSON)->
    if JSON && not _.isEmpty(JSON)
      for key, val of JSON.current_week.sectors
        JSON.current_week.sectors[key].subsectors ||= {}
        for skey, sval of JSON.current_week.sectors[key].subsectors
          JSON.current_week.sectors[key].subsectors[skey].activities ||= {}

      @state.current_week = Immutable(JSON.current_week)
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