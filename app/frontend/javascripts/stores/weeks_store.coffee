WeeksConstants = require '../constants/weeks_constants'
WeeksAPI = require '../sources/weeks_api'
Immutable = require 'seamless-immutable'

WeeksStore = Marty.createStore
  id: 'WeeksStore'
  displayName: 'WeeksStore'
  edit_lapa_timer: null

  getInitialState: ->
    weeks: {}
    current_week: {}
    sectors: {}
    subsectors: {}
    activities: {}
    UI:
      lapa_editing: false
      current_sector: null
      show_sectors: false
      show_stats: false

  setInitialState: (JSON, ok) ->
    if ok && not _.isEmpty(JSON)
      @state.current_week = Immutable(JSON.current_week)
      @state.sectors = Immutable(JSON.sectors)
      @state.subsectors = Immutable(JSON.subsectors)
      @state.activities = Immutable(JSON.activities)
      @state.weeks = Immutable(JSON.weeks)
      @hasChanged()
    else
      alert('arrr! boat is sinking')

  handlers:
    update_lapa: WeeksConstants.WEEK_LAPA_UPDATE
    setInitialState: WeeksConstants.WEEK_GET_RESPONSE
    setCurrentSector: WeeksConstants.WEEK_SELECT_SECTOR
    edit_lapa: WeeksConstants.WEEK_EDIT_LAPA
    show_sectors: WeeksConstants.WEEK_SHOW_SECTORS
    show_stats: WeeksConstants.WEEK_SHOW_STATS

  loadWeek: (id) ->
    WeeksAPI.get_week +id


  update_sector: (sector_id, params = {}) ->
    data =
      sectors:
        "#{sector_id}": params
    @state.current_week = @state.current_week.merge(data, {deep: true})
    @hasChanged()

  delete_sector: (sector_id) ->
    current_week = @state.current_week.asMutable({deep: true})
    current_week.sectors[sector_id] = null
    delete current_week.sectors[sector_id]
    @state.current_week = Immutable current_week
    @state.current_sector = null
    @hasChanged()

  move_sector: (sector_id, to) ->
    sectors = @getSectors()
    params =
      position: @get_new_position(sectors, sectors[sector_id].position, to)
    @update_sector(sector_id, params)


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
    current_week.sectors[sector_id].weeks[current_week.id].progress -= minus_count
    @state.current_week = Immutable current_week
    @hasChanged()

  move_subsector: (sector_id, subsector_id, to, dest = null) ->
    subsectors = @get_sector(sector_id).subsectors
    if dest isnt null
      subsector = subsectors[subsector_id]
      new_subsector = subsector.merge(
        sector_id: dest.sector_id
        editing: false
        position: @get_new_position(subsectors, subsector.position, 'last')
      )

      current_week = @getCurrentWeek()
      plus_count = 0
      for k, activity of new_subsector.activities
        plus_count += activity.count

      data =
        sectors:
          "#{dest.sector_id}":
            weeks:
              "#{@state.current_week.id}":
                progress: current_week.sectors[dest.sector_id].weeks[current_week.id].progress + plus_count
            subsectors:
              "#{subsector_id}": new_subsector
      @state.current_week = @state.current_week.merge(data, {deep: true})
      @delete_subsector(subsector.sector_id, subsector.id)
    else
      params =
        position: @get_new_position(subsectors, subsectors[subsector_id].position, to)
      @update_subsector(sector_id, subsector_id, params)

  update_activity: (sector_id, subsector_id, activity_id, params = {}) ->
    count_change = 0
    activity_old = @get_activity sector_id, subsector_id, activity_id
    count_old = if activity_old then activity_old.count else 0
    if _.has(params, 'count')
      count_change = params.count - count_old
    progress = @get_sector(sector_id).weeks[@state.current_week.id].progress + count_change

    data =
      sectors:
        "#{sector_id}":
          weeks:
            "#{@state.current_week.id}":
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
    current_week.sectors[sector_id].weeks[current_week.id].progress -= minus_count
    @state.current_week = Immutable current_week
    @hasChanged()

  move_activity: (sector_id, subsector_id, activity_id, to, dest = null) ->
    activities = @get_subsector(sector_id, subsector_id).activities
    if dest isnt null
      activity = activities[activity_id]
      new_activity = activity.merge(
        sector_id: dest.sector_id
        subsector_id: dest.subsector_id
        editing: false
        position: @get_new_position(activities, activity.position, 'last')
      )
      @update_activity(dest.sector_id, dest.subsector_id, activity.id, new_activity)
      @delete_activity(activity.sector_id, activity.subsector_id, activity.id)
    else
      params =
        position: @get_new_position(activities, activities[activity_id].position, to)
      @update_activity(sector_id, subsector_id, activity_id, params)


  edit_lapa: (week)->
    @state.UI.lapa_editing = !@state.UI.lapa_editing
    @hasChanged()

  update_lapa: (lapa) ->
    week_id = @state.current_week.id
    sectors = {}
    for sector_id, value of lapa
      sectors[sector_id] =
        weeks:
          "#{week_id}":
            lapa: value

    @state.current_week = @state.current_week.merge({sectors: sectors}, {deep: true})
    @hasChanged()

    clearTimeout @edit_lapa_timer
    callback = => WeeksAPI.update(week_id, {lapa: lapa})
    @edit_lapa_timer = setTimeout(callback , 500)

  getCurrentLapa: (sector_id) ->
    @state.sectors[sector_id].weeks[@state.current_week.id].lapa

  getCurrentWeek: ->
    @state.current_week

  getCurrentSector: ->
    sectors = @getSectors()
    if sectors && (!@state.UI.current_sector || !sectors[@state.UI.current_sector])
      position = 8388607
      for id, sector of sectors
        if sector.position < position
          position = sector.position
          @state.UI.current_sector = sector.id
    @state.UI.current_sector

  setCurrentSector: (sector)->
    @state.UI.current_sector = sector.id
    @hasChanged()

  show_sectors: ->
    if @state.UI.show_sectors
      @state.UI.show_sectors = false
    else
      @state.UI.show_sectors = true
      @state.UI.show_stats = false
    @hasChanged()


  show_stats: ->
    if @state.UI.show_stats
      @state.UI.show_stats = false
    else
      @state.UI.show_stats = true
      @state.UI.show_sectors = false
    @hasChanged()

  UI: ->
    @state.UI

  getSectors: ->
    @state.sectors

  get_sector: (sector_id) ->
    @state.sectors[sector_id]

  get_subsector: (subsector_id) ->
    @state.subsectors[subsector_id]

  get_activity: (activity_id) ->
    @state.activities[activity_id]

  get_new_position: (entries, position, to) ->
    # ranked-model gem range
    position_before = position_max = -8388607
    position_after = position_min = 8388607
    for id, entry of entries
      if entry.position > position and entry.position < position_after
        position_after = entry.position
      if entry.position < position and entry.position > position_before
        position_before = entry.position
      if entry.position < position_min
        position_min = entry.position
      if entry.position > position_max
        position_max = entry.position
    if to == 'up' && position_before isnt -8388607
      position = position_before - 0.001
    if to == 'down' && position_after isnt 8388607
      position = position_after + 0.001
    if to == 'first' && position_min isnt 8388607
      position = position_min - 0.001
    if to == 'last' && position_max isnt -8388607
      position = position_max + 0.001
    position

module.exports = WeeksStore