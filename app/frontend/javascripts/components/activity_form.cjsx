ActivityForm = React.createClass
  displayName: 'ActivityForm'

  propTypes: 
    activity: React.PropTypes.object.isRequired

  _onChange: (e) ->
    activity = @props.activity
    activity.name = e.target.value
    ActivitiesActionCreators.update(activity)

  render: ->
      <input
        id={'activity_' + @props.activity.id}
        placeholder='new activity'
        onChange={@_onChange}
        value={@props.activity.name}
        autoFocus={true}
      />


module.exports = ActivityForm