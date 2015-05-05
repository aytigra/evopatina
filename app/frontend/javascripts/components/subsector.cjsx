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
      <div className='row bg-info'>
        <label>{@props.subsector.name}</label>
        <button onClick={@_onActivityCreate}  className="btn btn-add btn-sm pull-right" aria-hidden="true">+</button>
      </div>
      <div>{activities}</div>
    </div>

module.exports = Subsector;