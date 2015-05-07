Activity = require './activity'
ActivitiesActionCreators = require '../actions/activities_actions'
SubsectorForm = require './subsector_form'
SubsectorsActionCreators = require '../actions/subsectors_actions'

Subsector = React.createClass
  displayName: 'Subsector'

  propTypes: 
    subsector: React.PropTypes.object.isRequired

  _onActivityCreate: (e) ->
    e.preventDefault()
    ActivitiesActionCreators.create @props.subsector.id

  _onEdit: (e) ->
    e.preventDefault()
    SubsectorsActionCreators.edit @props.subsector

  render: ->
    activities = []
    for id, activity of @props.subsector.activities
      activities.push(<Activity key={id} activity={activity}/>) if not activity.hidden

    if @props.subsector.edtitng
      subsector_elem = <SubsectorForm key={@props.subsector.id} subsector={@props.subsector}/>
    else
      subsector_elem = (
        <div>
          <label onDoubleClick={@_onDoubleClick}>{@props.subsector.name}</label>
          <button onClick={@_onEdit}  className="btn btn-default btn-sm pull-right">
            <span className="glyphicon glyphicon-pencil" aria-hidden="true"></span>
          </button>
          <button onClick={@_onActivityCreate}  className="btn btn-default btn-sm pull-right">
            <span className="glyphicon glyphicon-plus" aria-hidden="true"></span>
          </button>
        </div>
      )

    <div>
      <div className='row subsector bg-info'>
        {subsector_elem}
      </div>
      <div>{activities}</div>
    </div>

module.exports = Subsector;