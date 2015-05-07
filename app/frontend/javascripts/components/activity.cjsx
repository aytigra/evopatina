ActivitiesActionCreators = require '../actions/activities_actions'
ActivityForm = require './activity_form'

Activity = React.createClass
  displayName: 'Activity'

  getInitialState: ->
    show_desc: false

  propTypes: 
    activity: React.PropTypes.object.isRequired

  _onEdit: (e) ->
    e.preventDefault()
    ActivitiesActionCreators.edit @props.activity

  _showDescription: (e) ->
    @setState
      show_desc: !@state.show_desc

  render: ->
    if @props.activity.edtitng
      activity_elem = <ActivityForm key={@props.activity.id} activity={@props.activity}/>
    else
      activity_elem = (
        <div>
          <button onClick={@_onEditCount} className="btn btn-default btn-count btn-sm pull-left">
            0
          </button>
          <button onClick={@_onAddCount} className="btn btn-default btn-add-count btn-sm pull-left">
            <span className="glyphicon glyphicon-plus" aria-hidden="true"></span>
          </button>
          <label onClick={@_showDescription}>{@props.activity.name}</label>
          <button onClick={@_onEdit} className="btn btn-default btn-sm pull-right">
            <span className="glyphicon glyphicon-pencil" aria-hidden="true"></span>
          </button>
        </div>
      )

    if @state.show_desc
      desc_elem = <div className="description">{@props.activity.description}</div>

    <div className='row activity'>
      {activity_elem}
      {desc_elem}
    </div>

module.exports = Activity