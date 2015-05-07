ActivitiesActionCreators = require '../actions/activities_actions'
ActivityForm = require './activity_form'

Activity = React.createClass
  displayName: 'Activity'

  propTypes: 
    activity: React.PropTypes.object.isRequired

  _onEdit: (e) ->
    e.preventDefault()
    ActivitiesActionCreators.edit @props.activity

  render: ->
    if @props.activity.edtitng
      activity_elem = <ActivityForm key={@props.activity.id} activity={@props.activity}/>
    else
      activity_elem = (
        <div>
          <label onDoubleClick={@_onDoubleClick}>{@props.activity.name}</label>
          <button onClick={@_onEdit}  className="btn btn-default btn-sm pull-right">
            <span className="glyphicon glyphicon-pencil" aria-hidden="true"></span>
          </button>
        </div>
      )


    <div className='row activity'>
      {activity_elem}
    </div>

module.exports = Activity