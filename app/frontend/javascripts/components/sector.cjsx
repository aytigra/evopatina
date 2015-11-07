SectorHeader = require './sector_header'
SectorProgressBar = require './sector_progress_bar'
WeeksActionCreators = require '../actions/weeks_actions'
WeeksStore = require '../stores/weeks_store'

Sector = React.createClass
  displayName: 'Sector'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.sector isnt @props.sector or
    newProps.current isnt @props.current or
    newProps.lapa_editing isnt @props.lapa_editing

  _onSectorSelect: ->
    WeeksActionCreators.select_sector @props.sector

  _onLapaChange: (e)->
    WeeksActionCreators.update_lapa {"#{@props.sector.id}": e.target.value}

  render: ->
    current_class = if @props.current then 'bg-info' else ''
    lapa = @props.sector.weeks[WeeksStore.getCurrentWeek().id].lapa

    progress_bar = <SectorProgressBar data={@props.sector.weeks[WeeksStore.getCurrentWeek().id]}/>

    if @props.lapa_editing
      progress_bar =
        <div className='progress-bar-wrapper'>
          <div className='progress-bar-elem'>
            {progress_bar}
          </div>
          <input onChange={@_onLapaChange} value={lapa} autoFocus={@props.current && @props.lapa_editing}/>
        </div>

    <div className="sector row #{current_class}" onClick={@_onSectorSelect}>
      <SectorHeader key="header-#{@props.sector.id}" sector={@props.sector}/>
      {progress_bar}
    </div>

module.exports = Sector;