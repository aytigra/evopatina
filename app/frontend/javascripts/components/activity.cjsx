ActivitiesActionCreators = require '../actions/activities_actions'
#ActivityForm = require './activity_form'


Activity = React.createClass
  displayName: 'Activity'

  _onDoubleClick: ->
    ActivitiesActionCreators.edit(@props.activity)

  render: ->
    <div className='row'>
      <span>{if @props.activity.edtitng then "+" else "-"}</span>
      <span onDoubleClick={@_onDoubleClick}>{@props.activity.name}</span>
    </div>

module.exports = Activity