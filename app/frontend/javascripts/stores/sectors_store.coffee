SubsectorsStore = require('./subsectors_store');
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
      sector['progress'] = WeeksStore.getCurrentProgress id
      sector['lapa'] = WeeksStore.getCurrentLapa id
      result[id] = sector
    result

module.exports = SectorsStore