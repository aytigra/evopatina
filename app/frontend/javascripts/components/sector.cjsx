SectorHeader = require './sector_header'
SectorProgressBar = require './sector_progress_bar'
WeeksActionCreators = require '../actions/weeks_actions'
WeeksStore = require '../stores/weeks_store'

Sector = React.createClass
  displayName: 'Sector'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.sector isnt @props.sector or newProps.current isnt @props.current

  _onSectorSelect: ->
    WeeksActionCreators.select_sector @props.sector

  render: ->
    current_class = if @props.current then 'bg-info' else ''
    <div className="sector row #{current_class}" onClick={@_onSectorSelect}>
      <SectorHeader key="header-#{@props.sector.id}" sector={@props.sector}/>
      <SectorProgressBar key="progress-#{@props.sector.id}" data={@props.sector.weeks[WeeksStore.getCurrentWeek().id]}/>
    </div>

module.exports = Sector;