ActivitiesActionCreators = require '../actions/activities_actions'

ActivityForm = React.createClass
  displayName: 'ActivityForm'

  propTypes: 
    activity: React.PropTypes.object.isRequired

  _onChange: (e) ->
    activity = @props.activity
    activity.name = e.target.value
    ActivitiesActionCreators.update activity

  _onSave: ->
    ActivitiesActionCreators.save @props.activity

  _onCancel: ->
    ActivitiesActionCreators.cancel @props.activity

  _onDelete: ->
    ActivitiesActionCreators.destroy @props.activity

  render: ->
      if @props.activity.have_errors
        errors_elem = (
          <div title={JSON.stringify(@props.activity.errors)} className="pull-right text-danger">
            <span className="glyphicon glyphicon-alert" aria-hidden="true"></span>
          </div>
        )

      <div>
        <button onClick={@_onDelete} className="btn btn-default btn-sm pull-left">
          <span className="glyphicon glyphicon-trash" aria-hidden="true"></span>
        </button>
        <div className='activity_input'>
          <input
            id={'activity_' + @props.activity.id}
            placeholder='new activity'
            onChange={@_onChange}
            value={@props.activity.name}
            autoFocus={true}
          />
          </div>
        <button onClick={@_onSave} className="btn btn-default btn-sm pull-right">
          <span className="glyphicon glyphicon-ok" aria-hidden="true"></span>
        </button>
        <button onClick={@_onCancel} className="btn btn-default btn-sm pull-right">
          <span className="glyphicon glyphicon-remove" aria-hidden="true"></span>
        </button>
        {errors_elem}
      </div>



module.exports = ActivityForm