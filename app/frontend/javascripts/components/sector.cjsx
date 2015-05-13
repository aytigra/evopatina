Subsector = require './subsector'
SubsectorsActionCreators = require '../actions/subsectors_actions'
SectorHeader = require './sector_header'
SectorProgressBar = require './sector_progress_bar'

Sector = React.createClass
  displayName: 'Sector'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.sector isnt @props.sector

  _onSubsectorCreate: ->
    SubsectorsActionCreators.create @props.sector.id

  render: ->
    subsectors = []
    for id, subsector of @props.sector.subsectors
      subsectors.push(<Subsector key={id} subsector={subsector}/>) if not subsector.hidden

    <div className='sector-content col-lg-2 col-md-4 col-sm-6 col-xs-12'>
      <SectorHeader key="header-#{@props.sector.id}" sector={@props.sector}/>
      <SectorProgressBar key="progress-#{@props.sector.id}" sector={@props.sector}/>
      <div>{subsectors}</div>
      <div className='row subsector-add'>
        <button onClick={@_onSubsectorCreate}  className="btn btn-sm bg-info">
          <span className="glyphicon glyphicon-plus" aria-hidden="true"></span>
        </button>
      </div>
    </div>

module.exports = Sector;