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

  move_subsector: (sector_id, subsector_id, to) ->
    subsectors = @get_sector(sector_id).subsectors
    position = @get_new_position(subsectors, subsectors[subsector_id].position, to)
    data =
      sectors:
        "#{sector_id}":
          subsectors:
            "#{subsector_id}":
                  position: position

    @state.current_week = @state.current_week.merge(data, {deep: true})

    @hasChanged()

  update_activity: (sector_id, subsector_id, activity_id, params = {}) ->
    count_change = 0
    activity_old = @get_activity sector_id, subsector_id, activity_id
    count_old = if activity_old then activity_old.count else 0
    if _.has(params, 'count')
      count_change = params.count - count_old
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

  move_activity: (sector_id, subsector_id, activity_id, to) ->
    activities = @get_subsector(sector_id, subsector_id).activities
    position = @get_new_position(activities, activities[activity_id].position, to)
    data =
      sectors:
        "#{sector_id}":
          subsectors:
            "#{subsector_id}":
              activities:
                "#{activity_id}":
                  position: position

    @state.current_week = @state.current_week.merge(data, {deep: true})

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

  get_new_position: (entries, position, to) ->
    # ranked-model gem range
    position_before = -8388607
    position_after = 8388607
    for id, entry of entries
      if entry.position > position and entry.position < position_after
        position_after = entry.position
      if entry.position < position and entry.position > position_before
        position_before = entry.position
    if to == 'up' && position_before isnt -8388607
      position = position_before - 0.001
    if to == 'down' && position_after isnt 8388607
      position = position_after + 0.001
    position

module.exports = WeeksStore