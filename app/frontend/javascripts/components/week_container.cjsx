SectorsStore = require '../stores/sectors_store'
Sector = require './sector'

WeekContainer = React.createClass
  displayName: 'WeekContainer'



  render: ->
    sectors = []
    for id, sector of @props.sectors
      sectors.push(<Sector key={id} sector={sector}/>)

    <div>{sectors}</div>

module.exports = Marty.createContainer WeekContainer,
  listenTo: SectorsStore
  fetch:
    sectors: ->
      SectorsStore.getSectors()

  pending: ->
    <div className="warning">
      <h4>loading...</h4>
    </div>
  failed: (errors)->
    <div className="warning">
      <h4>Error</h4>
    </div>