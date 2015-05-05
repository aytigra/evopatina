ActivitiesActionCreators = require '../actions/activities_actions'
ActivityForm = React.createClass
  displayName: 'ActivityForm'

  propTypes: 
    activity: React.PropTypes.object.isRequired

  _onChange: (e) ->
    activity = @props.activity
    activity.name = e.target.value
    ActivitiesActionCreators.update(activity)

  _onSave: ->
    ActivitiesActionCreators.save(@props.activity)

  _onCancel: ->
    ActivitiesActionCreators.cancel(@props.activity)

  _onDelete: ->
    ActivitiesActionCreators.destroy(@props.activity)

  render: ->
      if @props.activity.have_errors
        errors_elem = <div title={JSON.stringify(@props.activity.errors)} className="pull-right"><span className="glyphicon glyphicon-alert" aria-hidden="true"></span></div>

      <div>
        <div onClick={@_onDelete}  className="glyphicon glyphicon-trash pull-left" aria-hidden="true"></div>
        <input
          id={'activity_' + @props.activity.id}
          placeholder='new activity'
          onChange={@_onChange}
          value={@props.activity.name}
          autoFocus={true}
        />
        {errors_elem}
        <div onClick={@_onSave} className="glyphicon glyphicon-ok pull-right" aria-hidden="true"></div>
        <div onClick={@_onCancel} className="glyphicon glyphicon-remove pull-right" aria-hidden="true"></div>
      </div>



module.exports = ActivityForm