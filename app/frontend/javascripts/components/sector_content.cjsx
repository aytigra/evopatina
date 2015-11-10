Subsector = require './subsector'
SubsectorsActionCreators = require '../actions/subsectors_actions'
EPutils = require '../ep_utils'

SectorContent = React.createClass
  displayName: 'SectorContent'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.sector isnt @props.sector

  _onSubsectorCreate: ->
    SubsectorsActionCreators.create @props.sector

  render: ->
    subsectors = EPutils.map_by_position @props.sector.subsectors, (subsector) ->
      <Subsector key={subsector.id} subsector={subsector}/> if not subsector.hidden

    <div className='sector-content col-lg-4 col-md-6 col-sm-7 col-xs-12'>
      <div>{subsectors}</div>
      <div className='row subsector-add'>
        <button onClick={@_onSubsectorCreate}  className="btn btn-sm bg-info">
          <span className="glyphicon glyphicon-plus" aria-hidden="true"></span>
        </button>
      </div>
    </div>

module.exports = SectorContent;