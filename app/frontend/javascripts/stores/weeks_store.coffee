WeeksConstants = require '../constants/weeks_constants'
WeeksAPI = require '../sources/weeks_api'
Immutable = require 'seamless-immutable'

WeeksStore = Marty.createStore
  id: 'WeeksStore'
  displayName: 'WeeksStore'

  getInitialState: ->
    weeks: {}
    current_week: {}
    sectors: {}
    subsectors: {}
    activities: {}
    UI:
      current_sector: null
      show_sectors: false
      show_stats: false

  setInitialState: (JSON, ok) ->
    if ok && not _.isEmpty(JSON)
      @state.current_week = Immutable(JSON.current_day)
      @state.sectors = Immutable(JSON.sectors)
      @state.subsectors = Immutable(JSON.subsectors)
      @state.activities = Immutable(JSON.activities)
      @hasChanged()
    else
      alert('arrr! boat is sinking')

  handlers:
    setInitialState: WeeksConstants.WEEK_GET_RESPONSE
    setCurrentSector: WeeksConstants.WEEK_SELECT_SECTOR
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
    data =
      sectors: @array_move_element(@state.current_week.sectors.asMutable(), id, to)
    @state.current_week = @state.current_week.merge(data, {deep: true})
    @hasChanged()

  update_subsector: (id, params = {}) ->
    data =
      "#{id}": params
    @state.subsectors = @state.subsectors.merge(data, {deep: true})
    # bubble changes up tree
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


  new_activity: (subsector_id) ->
    activity_id = _.uniqueId('new_activity')
    data =
      "#{activity_id}":
        id: activity_id
        subsector_id: subsector_id
        name: ''
        description: ''
        editing: true
        show_hidden: false
        count: 0

    @state.activities = @state.activities.merge data, {deep: true}

    activities = @get_subsector(subsector_id).activities.asMutable()
    activities.push(activity_id)
    @update_subsector subsector_id,
      activities: activities

  update_activity: (id, params = {}) ->
    activity = @get_activity id
    sector_id = @get_subsector(activity.subsector_id).sector_id
    week_id = @state.current_week.id
    count_change = if _.has(params, 'count') then params.count - activity.count else 0
    progress = @get_sector(sector_id).weeks[week_id].progress + count_change

    data =
      "#{id}": params
    @state.activities = @state.activities.merge(data, {deep: true})

    data =
      "#{sector_id}":
        weeks:
          "#{week_id}":
            progress: progress
    @state.sectors = @state.sectors.merge(data, {deep: true})

    # bubble changes up tree
    @update_subsector activity.subsector_id, {uniq_ver: _.uniqueId('subsector')}

  update_activity_id: (old_id, id) ->
    activity = @get_activity(old_id).asMutable()
    activity.id = id
    data =
      "#{id}": activity
    @state.activities = @state.activities.merge(data, {deep: true})

    activities = @get_subsector(activity.subsector_id).activities.asMutable()
    activities[activities.indexOf(old_id)] = id
    @update_subsector activity.subsector_id,
      activities: activities

  delete_activity: (id) ->
    activity = @get_activity(id)
    subsector = @get_subsector(activity.subsector_id)
    sector = @state.sectors[subsector.sector_id]
    week_id = @state.current_week.id


    data =
      "#{subsector.id}":
        activities: _.without(subsector.activities, id)
    @state.subsectors = @state.subsectors.merge(data, {deep: true})

    @update_sector subsector.sector_id,
      weeks:
        "#{week_id}":
          progress:  @get_sector(subsector.sector_id).weeks[week_id].progress - activity.count

  move_activity: (id, to, dest = null) ->
    if dest and dest.subsector_id
      activity = @get_activity(id)
      from_subsector = @state.subsectors[activity.subsector_id]
      to_subsector = @state.subsectors[dest.subsector_id]
      week_id = @state.current_week.id

      data =
        "#{id}":
          subsector_id: dest.subsector_id
          editing: false
      @state.activities = @state.activities.merge(data, {deep: true})

      to_activities = to_subsector.activities.asMutable()
      to_activities.push(id)

      data =
        "#{from_subsector.id}":
          activities: _.without(from_subsector.activities, id)
        "#{to_subsector.id}":
          activities: to_activities
      @state.subsectors = @state.subsectors.merge(data, {deep: true})

      if from_subsector.sector_id isnt to_subsector.sector_id
        from_sector = @state.sectors[from_subsector.sector_id]
        to_sector = @state.sectors[to_subsector.sector_id]
        data =
          "#{from_sector.id}":
            weeks:
              "#{week_id}":
                progress: from_sector.weeks[week_id].progress - activity.count
          "#{to_sector.id}":
            weeks:
              "#{week_id}":
                progress: to_sector.weeks[week_id].progress + activity.count
        @state.sectors = @state.sectors.merge(data, {deep: true})

      @hasChanged()
    else
      subsector = @state.subsectors[@get_activity(id).subsector_id]
      @update_subsector subsector.id,
        activities: @array_move_element(subsector.activities.asMutable(), id, to)


  getCurrentWeek: ->
    @state.current_week

  getCurrentSector: ->
    sectors = @getCurrentWeek().sectors
    if sectors && (!@state.UI.current_sector || !@state.sectors[@state.UI.current_sector])
      @state.UI.current_sector = sectors[0]
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

  get_week: (week_id) ->
    @state.weeks[week_id]

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
