WeeksStore = require '../stores/weeks_store'

Sector = require './sector'
SectorContent = require './sector_content'

WeekContent = React.createClass
  displayName: 'WeekContent'

  render: ->
    sectors = []
    if current_sector = WeeksStore.getCurrentSector()
      for id, sector of @props.sectors
        sectors.push(<Sector key={id} sector={sector}/>)
      sector_content = <SectorContent  key={current_sector.id} sector={current_sector} />
    else
      content_error = <div className='error'>something wrong with data, try to reload page</div>

    <div>
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