SubsectorsStore = require('./subsectors_store');

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
    for id, sector of @state.sectors[sector_id]
      sector['subsectors'] = SubsectorsStore.getSubsectors id
      result[id] = sector
    result

module.exports = SectorsStore