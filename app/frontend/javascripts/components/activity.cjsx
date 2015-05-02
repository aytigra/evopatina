ActivitiesActionCreators = require '../actions/activities_actions'
ActivityForm = require './activity_form'


Activity = React.createClass
  displayName: 'Activity'

  propTypes: 
    activity: React.PropTypes.object.isRequired

  _onDoubleClick: ->
    ActivitiesActionCreators.edit(@props.activity)

  render: ->
    if @props.activity.edtitng
      activity_elem = <ActivityForm key={@props.activity.id} activity={@props.activity}/>
    else
      activity_elem = <span onDoubleClick={@_onDoubleClick}>{@props.activity.name}</span>


    <div className='row'>
      {activity_elem}
    </div>

module.exports = Activity