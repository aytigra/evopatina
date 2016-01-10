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

  setInitialState: (JSON, ok) ->
    if ok && not _.isEmpty(JSON)
      @state.current_day = Immutable(JSON.current_day)
      @state.sectors = Immutable(JSON.sectors)
      @state.subsectors = Immutable(JSON.subsectors)
      @state.activities = Immutable(JSON.activities)
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

  UI: ->
    @state.UI

  subsector_count: (id) ->
    count = 0
    for aid in @get_subsector(id).activities
      count += @get_activity(aid).count
    count

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
    @hasChanged()

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
    # bubble changes up tree
    @update_sector sector.id,
      subsectors: _.without(sector.subsectors, id)
      progress:  sector.progress - @subsector_count(id)

  move_subsector: (id, to, dest = null) ->
    subsector = @get_subsector(id)
    from_sector = @get_sector(subsector.sector_id)
    if dest and dest.sector_id
      to_sector = @get_sector(dest.sector_id)
      count = @subsector_count(id)

      @set_subsector id,
        sector_id: dest.sector_id
        editing: false

      @set_sector from_sector.id,
        subsectors: _.without(from_sector.subsectors, id)
        progress: from_sector.progress - count
      # bubble changes up tree
      @update_sector to_sector.id,
        subsectors: to_sector.subsectors.concat(id)
        progress: to_sector.progress + count
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
    activity = @get_activity(id)
    sector_id = @get_subsector(activity.subsector_id).sector_id
    count_change = if _.has(params, 'count') then params.count - activity.count else 0
    progress = @get_sector(sector_id).progress + count_change

    @set_activity id, params
    @set_sector sector_id,
      progress: progress

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

    @set_sector subsector.sector_id,
      progress:  @get_sector(subsector.sector_id).progress - activity.count

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
        from_sector = @get_sector(from_subsector.sector_id)
        to_sector = @get_sector(to_subsector.sector_id)
        @set_sector from_sector.id,
          progress: from_sector.progress - activity.count
        @set_sector to_sector.id,
          progress: to_sector.progress + activity.count

      @set_subsector from_subsector.id,
        activities: _.without(from_subsector.activities, id)
      # bubble changes up tree
      @update_subsector to_subsector.id,
        activities: to_subsector.activities.concat(id)
    else
      # bubble changes up tree
      @update_subsector from_subsector.id,
        activities: EPutils.array_move_element(from_subsector.activities.asMutable(), id, to)

module.exports = AppStore
