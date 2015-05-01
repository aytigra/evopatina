SectorsStore = Marty.createStore
  id: 'SectorsStore'
  displayName: 'SectorsStore'

  getInitialState: ->
    sectors: {}

  setInitialState: (data)->
    @setState 
      sectors: data


module.exports = SectorsStore