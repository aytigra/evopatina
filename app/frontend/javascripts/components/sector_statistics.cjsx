SectorHeader = require './sector_header'
SectorProgressBar = require './sector_progress_bar'
EPutils = require '../ep_utils'

SectorStatistics = React.createClass
  displayName: 'SectorStatistics'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.sector isnt @props.sector or newProps.current isnt @props.current

  render: ->
    weeks = []
    weeks_ids = Object.keys(@props.sector.weeks)
    weeks_ids.sort( (a, b) =>
     @props.sector.weeks[a].position - @props.sector.weeks[b].position
    )

    weeks_ids.forEach (id) =>
      status = EPutils.sector_status_icon(@props.sector.weeks[id])
      weeks.push(
        <div style={{display: 'table', position: 'relative'}}>
          <span className="glyphicon glyphicon-#{status}"></span>
          <div style={{display: 'table-cell', width: '100%'}}>
            <SectorProgressBar key={id} data={@props.sector.weeks[id]}/>
          </div>
        </div>
      )

    <div className="sector-statistics col-lg-4 col-md-3 col-sm-3 col-xs-12">
      <SectorHeader key="header-#{@props.sector.id}" sector={@props.sector}/>
      {weeks}
    </div>

module.exports = SectorStatistics;