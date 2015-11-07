WeeksStore = require '../stores/weeks_store'

WeekHeader = require './week_header'
Sector = require './sector'
SectorContent = require './sector_content'
SectorStatistics = require './sector_statistics'

WeekContent = React.createClass
  displayName: 'WeekContent'

  render: ->
    week = WeeksStore.getCurrentWeek()
    sectors = []
    current_sector = WeeksStore.getCurrentSector()
    for id, sector of @props.sectors
      current = sector.id == current_sector
      sectors.push(<Sector key={id} sector={sector} current={current} lapa_editing={week.lapa_editing}/>)

    <div id='week-content' className='row'>
      <WeekHeader week={week} />
      <div className='sector-list col-lg-4 col-md-3 col-sm-5 col-xs-12'>
        {sectors}
      </div>
      <SectorContent  key='content' sector={@props.sectors[current_sector]} />
      <SectorStatistics  key='statistics' sector={@props.sectors[current_sector]} />
    </div>


module.exports = Marty.createContainer WeekContent,
  listenTo: [WeeksStore]
  fetch:
    sectors: ->
      WeeksStore.getSectors()

  pending: ->
    <div className="warning">
      <h4>loading...</h4>
    </div>
  failed: (errors)->
    <div className="warning">
      <h4>Error</h4>
    </div>