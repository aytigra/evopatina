SectorHeader = require './sector_header'
SectorProgressBar = require './sector_progress_bar'

Sector = React.createClass
  displayName: 'Sector'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.sector isnt @props.sector

  render: ->
    <div className='sector-content row'>
      <SectorHeader key="header-#{@props.sector.id}" sector={@props.sector}/>
      <SectorProgressBar key="progress-#{@props.sector.id}" sector={@props.sector}/>
    </div>

module.exports = Sector;