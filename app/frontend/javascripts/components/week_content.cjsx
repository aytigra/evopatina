WeeksStore = require '../stores/weeks_store'

WeekHeader = require './week_header'
Sector = require './sector'
SectorContent = require './sector_content'

WeekContent = React.createClass
  displayName: 'WeekContent'

  render: ->
    sectors = []
    if current_sector = WeeksStore.getCurrentSector()
      for id, sector of @props.sectors
        current = sector.id == current_sector
        sectors.push(<Sector key={id} sector={sector} current={current}/>)
      sector_content = <SectorContent  key={current_sector} sector={@props.sectors[current_sector]} />
    else
      content_error = <div className='error'>something wrong with data, try to reload page</div>

    <div id='week-content' className='row'>
      <WeekHeader week={WeeksStore.getCurrentWeek()} />
      <div className='sector-list col-lg-3 col-md-6 col-sm-12 col-xs-12'>
        {sectors}
      </div>
      {sector_content}
      {content_error}
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