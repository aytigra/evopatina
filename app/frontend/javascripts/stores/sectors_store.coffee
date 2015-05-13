WeeksStore = require('./weeks_store');

SectorsStore = Marty.createStore
  id: 'SectorsStore'
  displayName: 'SectorsStore'

  getInitialState: ->
    sectors: {}

  setInitialState: (data) ->
    @setState 
      sectors: data

  getSectors: ->
    result = {}
    for id, sector of @state.sectors
      sector['subsectors'] = SubsectorsStore.getSubsectors id
      sector['progress'] = 0
      for ids, subsector of sector['subsectors']
        sector['progress'] += subsector.count
      sector['lapa'] = WeeksStore.getCurrentLapa id
      result[id] = sector
    result

module.exports = SectorsStore