Subsector = require './subsector'
SubsectorsActionCreators = require '../actions/subsectors_actions'

SectorContent = React.createClass
  displayName: 'SectorContent'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.sector isnt @props.sector

  _onSubsectorCreate: ->
    SubsectorsActionCreators.create @props.sector

  render: ->
    subsectors = []
    subsectors_ids = Object.keys(@props.sector.subsectors)
    subsectors_ids.sort( (a, b) =>
     @props.sector.subsectors[a].position - @props.sector.subsectors[b].position
    )

    subsectors_ids.forEach (id) =>
      subsector = @props.sector.subsectors[id]
      subsectors.push(<Subsector key={id} subsector={subsector}/>) if not subsector.hidden

    <div className='sector-content col-lg-3 col-md-6 col-sm-12 col-xs-12'>
      <div>{subsectors}</div>
      <div className='row subsector-add'>
        <button onClick={@_onSubsectorCreate}  className="btn btn-sm bg-info">
          <span className="glyphicon glyphicon-plus" aria-hidden="true"></span>
        </button>
      </div>
    </div>

module.exports = SectorContent;