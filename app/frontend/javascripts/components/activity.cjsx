ActivitiesActionCreators = require '../actions/activities_actions'
ActivityForm = require './activity_form'


Activity = React.createClass
  displayName: 'Activity'

  propTypes: 
    activity: React.PropTypes.object.isRequired

  _onDoubleClick: (e) ->
    e.preventDefault()
    ActivitiesActionCreators.edit @props.activity

  render: ->
    if @props.activity.edtitng
      activity_elem = <ActivityForm key={@props.activity.id} activity={@props.activity}/>
    else
      activity_elem = <label onDoubleClick={@_onDoubleClick}>{@props.activity.name}</label>


    <div className='row activity'>
      {activity_elem}
    </div>

module.exports = Activity