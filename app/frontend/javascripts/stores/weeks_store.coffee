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


  update_sector: (id, params = {}) ->
    data =
      "#{id}": params
    @state.sectors = @state.sectors.merge(data, {deep: true})
    @hasChanged()

  delete_sector: (id) ->
    @state.sectors = @state.sectors.without("#{id}")
    @state.UI.current_sector = null
    @hasChanged()

  move_sector: (id, to) ->
    sectors = @getSectors()
    params =
      position: @get_new_position(sectors, sectors[id].position, to)
    @update_sector(id, params)

  update_subsector: (id, params = {}) ->
    data =
      "#{id}": params
    @state.subsectors = @state.subsectors.merge(data, {deep: true})
    @update_sector @get_subsector(id).sector_id, {uniq_ver: _.uniqueId('sector')}

  new_subsector: (sector_id) ->
    subsector_id = _.uniqueId('new_subsector')
    data =
      "#{subsector_id}":
        id: subsector_id
        sector_id: sector_id
        name: ''
        description: ''
        activities: []
        editing: true
        show_hidden: false
        position: 9000000

    @state.subsectors = @state.subsectors.merge data, {deep: true}

    subsectors = @get_sector(sector_id).subsectors.asMutable()
    subsectors.push(subsector_id)
    @update_sector sector_id,
      subsectors: subsectors

  update_subsector_id: (old_id, id) ->
    subsector = @get_subsector(old_id).asMutable()
    subsector.id = id
    data =
      "#{id}": subsector
    @state.subsectors = @state.subsectors.merge(data, {deep: true})

    subsectors = @get_sector(subsector.sector_id).subsectors.asMutable()
    subsectors[subsectors.indexOf(old_id)] = id
    @update_sector subsector.sector_id,
      subsectors: subsectors

  delete_subsector: (id) ->
    subsector = @get_subsector(id)
    minus_count = 0
    for aid in subsector.activities
      minus_count += @get_activity(aid).count

    week_id = @state.current_week.id
    sector = @state.sectors[subsector.sector_id]
    @update_sector sector.id
      subsectors: _.without(sector.subsectors, id)
      weeks:
        "#{week_id}":
          progress:  sector.weeks[week_id].progress - minus_count

  move_subsector: (subsector_id, to, dest = null) ->
    if dest and dest.sector_id
      subsector = @get_subsector(subsector_id)
      from_sector = @state.sectors[subsector.sector_id]
      to_sector = @state.sectors[dest.sector_id]
      week_id = @state.current_week.id

      data =
        "#{subsector_id}":
          sector_id: dest.sector_id
          editing: false
      @state.subsectors = @state.subsectors.merge(data, {deep: true})

      count = 0
      for aid in subsector.activities
        count += @get_activity(aid).count

      to_subsectors = to_sector.subsectors.asMutable()
      to_subsectors.push(subsector_id)

      data =
        "#{from_sector.id}":
          subsectors: _.without(from_sector.subsectors, subsector_id)
          weeks:
            "#{week_id}":
              progress: from_sector.weeks[week_id].progress - count
        "#{to_sector.id}":
          subsectors: to_subsectors
          weeks:
            "#{week_id}":
              progress: to_sector.weeks[week_id].progress + count
      @state.sectors = @state.sectors.merge(data, {deep: true})

      @hasChanged()
    else
      sector = @state.sectors[@get_subsector(subsector_id).sector_id]
      @update_sector sector.id,
        subsectors: @array_move_element(sector.subsectors.asMutable(), subsector_id, to)


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

  array_move_element: (array, element, to) ->
    pos = array.indexOf(element)
    if to == 'up' && pos > 0
      array[pos] = array[pos - 1]
      array[pos - 1] = element
    if to == 'down' && pos < array.length - 1
      array[pos] = array[pos + 1]
      array[pos + 1] = element
    if to == 'first'
      array.splice(pos, 1)
      array.unshift(element)
    if to == 'last'
      array.splice(pos, 1)
      array.push(element)
    array

module.exports = WeeksStore