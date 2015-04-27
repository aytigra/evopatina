Activity = React.createClass
  displayName: 'Activity'
  render: ->
    <div className='row'>
      <span>{@props.activity.name}</span>
      <a href='link_to edit_activity_path(activity) do'>
        <span className="glyphicon glyphicon-pencil" aria-hidden="true"></span>
      </a>
      <a href='link_to activity, method: :delete, data: { confirm: Are you sure? } do'>
        <span className="glyphicon glyphicon-trash" aria-hidden="true"></span>
      </a>
    </div>

module.exports = Activity;