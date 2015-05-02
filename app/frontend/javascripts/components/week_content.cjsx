SectorsStore = require '../stores/sectors_store'
SubsectorsStore = require '../stores/subsectors_store'
ActivitiesStore = require '../stores/activities_store'
WeeksStore = require '../stores/weeks_store'

Sector = require './sector'

WeekContent = React.createClass
  displayName: 'WeekContent'



  render: ->
    sectors = []
    for id, sector of @props.sectors
      sectors.push(<Sector key={id} sector={sector}/>)

    <div>{sectors}</div>

module.exports = Marty.createContainer WeekContent,
  listenTo: [SectorsStore, SubsectorsStore, ActivitiesStore, WeeksStore]
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