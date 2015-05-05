Activity = require './activity'
ActivitiesActionCreators = require '../actions/activities_actions'

Subsector = React.createClass
  displayName: 'Subsector'

  _onActivityCreate: ->
    ActivitiesActionCreators.create(@props.subsector.id)

  render: ->
    activities = []
    for id, activity of @props.subsector.activities
      activities.push(<Activity key={id} activity={activity}/>) if not activity.hidden
    <div>
      <div className='row subsector bg-info'>
        <label>{@props.subsector.name}</label>
        <button onClick={@_onActivityCreate}  className="btn btn-default btn-sm pull-right">
          <span className="glyphicon glyphicon-plus" aria-hidden="true"></span>
        </button>
      </div>
      <div>{activities}</div>
    </div>

module.exports = Subsector;