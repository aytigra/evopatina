UIConstants = require '../constants/ui_constants'
Immutable = require 'seamless-immutable'
EPutils = require '../ep_utils'

AppStore = Marty.createStore
  id: 'AppStore'
  displayName: 'AppStore'

  getInitialState: ->
    weeks: {}
    current_day: {}
    sectors: {}
    subsectors: {}
    activities: {}
    UI:
      current_sector: null
      show_sectors: false
      show_stats: false
      stats_ver: null

  setInitialState: (JSON, ok) ->
    if ok && not _.isEmpty(JSON)
      @state.current_day = Immutable(JSON.current_day)
      @state.sectors = Immutable(JSON.sectors)
      @state.subsectors = Immutable(JSON.subsectors)
      @state.activities = Immutable(JSON.activities)
      @state.progress = Immutable(JSON.progress)
      @hasChanged()
    else
      alert('arrr! boat is sinking')

  # getters/setters

  get_day: ->
    @state.current_day

  set_day: (params = {}) ->
    @state.current_day = @state.current_day.merge(params, {deep: true})

  get_sector: (id) ->
    @state.sectors[id]

  set_sector: (id, params = {}) ->
    data =
      "#{id}": params
    @state.sectors = @state.sectors.merge(data, {deep: true})

  get_subsector: (id) ->
    @state.subsectors[id]

  set_subsector: (id, params = {}) ->
    data =
      "#{id}": params
    @state.subsectors = @state.subsectors.merge(data, {deep: true})

  get_activity: (id) ->
    @state.activities[id]

  set_activity: (id, params = {}) ->
    data =
      "#{id}": params
    @state.activities = @state.activities.merge(data, {deep: true})

  get_progress: (sector, day) ->
    if not day
      day = @get_day().id
    if @state.progress[sector] then @state.progress[sector][day] else 0

  set_progress: (sector, day, progress) ->
    if not day
      day = @get_day().id
    data =
      "#{sector}":
        "#{day}": progress
    @redraw_stats()
    @state.progress = @state.progress.merge(data, {deep: true})

  get_sector_progress_data: (sector) ->
    result = []
    for day in @get_day().days
      result.push @get_progress(sector, day) * 100
    result

  UI: ->
    @state.UI

  # some math

  sector_status: (sector) ->
    days = @get_day().days.asMutable()
    p1 = @get_progress sector, days.pop()
    p2 = @get_progress sector, days.pop()
    p3 = @get_progress sector, days.pop()
    p2 = if p2 > 2/3 then 2/3 else p2
    p3 = if p3 > 1/3 then 1/3 else p3
    p1 + p2 + p3


  subsector_count: (id) ->
    count = 0
    for aid in @get_subsector(id).activities
      count += @get_activity(aid).count
    count

  # progress reducers

  change_progress: (sector, day, change) ->
    @set_progress(sector, day, @get_progress(sector, day) + change)

  # UI reducers

  handlers:
    setCurrentSector: UIConstants.UI_SELECT_SECTOR
    show_sectors: UIConstants.UI_SHOW_SECTORS
    show_stats: UIConstants.UI_SHOW_STATS

  getCurrentSector: ->
    sectors = @get_day().sectors
    if sectors && _.indexOf(sectors, @state.UI.current_sector) < 0
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
    @redraw_stats()
    @hasChanged()

  redraw_stats: ->
    @state.UI.stats_ver = _.uniqueId('stats_ver')

  # sectors reducers

  new_sector: ->
    sector_id = _.uniqueId('new_sector')
    @set_sector sector_id,
      id: sector_id
      name: ''
      description: ''
      icon: ''
      color: ''
      subsectors: []
      progress: 0
      editing: true

    @set_day
      sectors: @get_day().sectors.concat(sector_id)

    @hasChanged()

  update_sector_id: (old_id, id) ->
    sector = @get_sector(old_id).asMutable()
    sector.id = id
    @set_sector id, sector

    sectors = @get_day().sectors.asMutable()
    sectors[sectors.indexOf(old_id)] = id
    @set_day
      sectors: sectors
    @state.UI.current_sector = id

    @hasChanged()

  update_sector: (id, params = {}) ->
    @set_sector id, params
    @hasChanged()

  delete_sector: (id) ->
    @set_day
      sectors: _.without(@get_day().sectors, id)
    @state.UI.current_sector = null
    @hasChanged()

  move_sector: (id, to) ->
    @set_day
      sectors: EPutils.array_move_element(@get_day().sectors.asMutable(), id, to)
    @hasChanged()

  # subsectors reducers

  new_subsector: (sector_id) ->
    subsector_id = _.uniqueId('new_subsector')
    @set_subsector subsector_id,
      id: subsector_id
      sector_id: sector_id
      name: ''
      description: ''
      activities: []
      editing: true
      show_hidden: false

    # bubble changes up tree
    @update_sector sector_id,
      subsectors: @get_sector(sector_id).subsectors.concat(subsector_id)

  update_subsector: (id, params = {}) ->
    @set_subsector id, params
    # bubble changes up tree
    @update_sector @get_subsector(id).sector_id, {uniq_ver: _.uniqueId('sector')}

  update_subsector_id: (old_id, id) ->
    subsector = @get_subsector(old_id).asMutable()
    subsector.id = id
    @set_subsector id, subsector

    subsectors = @get_sector(subsector.sector_id).subsectors.asMutable()
    subsectors[subsectors.indexOf(old_id)] = id
    # bubble changes up tree
    @update_sector subsector.sector_id,
      subsectors: subsectors

  delete_subsector: (id) ->
    sector = @get_sector(@get_subsector(id).sector_id)
    @change_progress sector.id, null, -@subsector_count(id)
    # bubble changes up tree
    @update_sector sector.id,
      subsectors: _.without(sector.subsectors, id)

  move_subsector: (id, to, dest = null) ->
    subsector = @get_subsector(id)
    from_sector = @get_sector(subsector.sector_id)
    if dest and dest.sector_id
      to_sector = @get_sector(dest.sector_id)
      count = @subsector_count(id)

      @set_subsector id,
        sector_id: dest.sector_id
        editing: false

      @change_progress from_sector.id, null, -count
      @change_progress to_sector.id, null, count

      @set_sector from_sector.id,
        subsectors: _.without(from_sector.subsectors, id)
      # bubble changes up tree
      @update_sector to_sector.id,
        subsectors: to_sector.subsectors.concat(id)
    else
      # bubble changes up tree
      @update_sector from_sector.id,
        subsectors: EPutils.array_move_element(from_sector.subsectors.asMutable(), id, to)

  # activities reducers

  new_activity: (subsector_id) ->
    activity_id = _.uniqueId('new_activity')
    @set_activity activity_id,
      id: activity_id
      subsector_id: subsector_id
      name: ''
      description: ''
      editing: true
      show_hidden: false
      count: 0

    # bubble changes up tree
    @update_subsector subsector_id,
      activities: @get_subsector(subsector_id).activities.concat(activity_id)

  update_activity: (id, params = {}) ->
    activity = @get_activity(id) # old activity
    # params.count - new count for activity
    if _.has(params, 'count')
      count_change =  params.count - activity.count
      sector_id = @get_subsector(activity.subsector_id).sector_id
      @change_progress sector_id, null, count_change
    @set_activity id, params
    # bubble changes up tree
    @update_subsector activity.subsector_id, {uniq_ver: _.uniqueId('subsector')}

  update_activity_id: (old_id, id) ->
    activity = @get_activity(old_id).asMutable()
    activity.id = id
    @set_activity id, activity

    activities = @get_subsector(activity.subsector_id).activities.asMutable()
    activities[activities.indexOf(old_id)] = id
    # bubble changes up tree
    @update_subsector activity.subsector_id,
      activities: activities

  delete_activity: (id) ->
    activity = @get_activity(id)
    subsector = @get_subsector(activity.subsector_id)
    @change_progress subsector.sector_id, null, -activity.count
    # bubble changes up tree
    @update_subsector subsector.id,
      activities: _.without(subsector.activities, id)


  move_activity: (id, to, dest = null) ->
    activity = @get_activity(id)
    from_subsector = @get_subsector(activity.subsector_id)
    if dest and dest.subsector_id
      to_subsector = @get_subsector(dest.subsector_id)

      @set_activity id,
        subsector_id: dest.subsector_id
        editing: false

      if from_subsector.sector_id isnt to_subsector.sector_id
        @change_progress from_subsector.sector_id, null, -activity.count
        @change_progress to_subsector.sector_id, null, activity.count

      @set_subsector to_subsector.id,
        activities: to_subsector.activities.concat(id)
      # bubble changes up tree for visible sector
      @update_subsector from_subsector.id,
        activities: _.without(from_subsector.activities, id)
    else
      # bubble changes up tree
      @update_subsector from_subsector.id,
        activities: EPutils.array_move_element(from_subsector.activities.asMutable(), id, to)

module.exports = AppStore
