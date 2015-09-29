ActivitiesActionCreators = require '../actions/activities_actions'
ActivityForm = require './activity_form'
ActivityCountForm = require './activity_count_form'

Activity = React.createClass
  displayName: 'Activity'

  getInitialState: ->
    show_desc: false

  propTypes: 
    activity: React.PropTypes.object.isRequired

  shouldComponentUpdate: (newProps, newState) ->
    newProps.activity isnt @props.activity or newState.show_desc isnt @state.show_desc

  _onEdit: (e) ->
    e.preventDefault()
    ActivitiesActionCreators.edit @props.activity

  _onEditCount: (e) ->
    e.preventDefault()
    ActivitiesActionCreators.edit_count @props.activity

  _onIncrementCount: (e) ->
    e.preventDefault()
    params =
      count: @props.activity.count + 1
    ActivitiesActionCreators.update @props.activity, params

  _showDescription: (e) ->
    @setState
      show_desc: !@state.show_desc

  _onShow: ->
    params =
      hidden: false
    ActivitiesActionCreators.update @props.activity, params

  render: ->
    increment_button_disabled = ''
    if typeof @props.activity.id is "string"
      increment_button_disabled = 'disabled'

    if @props.activity.editing
      activity_elem = <ActivityForm key={@props.activity.id} activity={@props.activity}/>
    else if @props.activity.editing_count
      activity_elem = <ActivityCountForm key="count-#{@props.activity.id}" activity={@props.activity}/>
    else
      label = (<label onClick={@_showDescription}>{@props.activity.name}</label>)

      if @props.activity.hidden
        activity_elem = (
          <div>
            {label}
            <button onClick={@_onShow} className="btn btn-default btn-sm pull-right">
              <span className="glyphicon glyphicon-eye-open" aria-hidden="true"></span>
            </button>
          </div>
        )
      else
        activity_elem = (
          <div>
            <button onClick={@_onEditCount} className="btn btn-default btn-count btn-sm pull-left" disabled={increment_button_disabled}>
              {@props.activity.count || 0}
            </button>
            <button onClick={@_onIncrementCount} className="btn btn-default btn-add-count btn-sm pull-left" disabled={increment_button_disabled}>
              <span className="glyphicon glyphicon-plus" aria-hidden="true"></span>
            </button>
            {label}
            <button onClick={@_onEdit} className="btn btn-default btn-sm pull-right">
              <span className="glyphicon glyphicon-pencil" aria-hidden="true"></span>
            </button>
          </div>
        )

    if @state.show_desc and not @props.activity.editing
      desc_elem = <div className="description">{@props.activity.description}</div>

    <div className='row activity'>
      {activity_elem}
      {desc_elem}
    </div>

module.exports = Activity