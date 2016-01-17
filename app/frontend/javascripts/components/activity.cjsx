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
    ActivitiesActionCreators.update_count @props.activity, params

  _showDescription: (e) ->
    @setState
      show_desc: !@state.show_desc


  render: ->
    increment_button_disabled = ''
    if typeof @props.activity.id is "string"
      increment_button_disabled = 'disabled'

    if @props.activity.editing
      activity_elem = <ActivityForm key={@props.activity.id} activity={@props.activity}/>
    else if @props.activity.editing_count
      activity_elem = <ActivityCountForm key="count-#{@props.activity.id}" activity={@props.activity}/>
    else
      activity_elem = (
        <div className='list-name'>
          <div className='btns-left'>
            <button onClick={@_onEditCount} className="btn btn-default btn-count btn-sm" disabled={increment_button_disabled} title={I18n.fragments.edit}>
              {@props.activity.count || 0}
            </button>
            <button onClick={@_onIncrementCount} className="btn btn-default btn-add-count btn-sm" disabled={increment_button_disabled} title={I18n.fragments.add}>
              <span className="glyphicon glyphicon-plus" aria-hidden="true"></span>
            </button>
          </div>
          <label onClick={@_showDescription}>{@props.activity.name}</label>
          <div className='btns-right'>
            <button onClick={@_onEdit} className="btn btn-default btn-sm" title={I18n.activities.edit}>
              <span className="glyphicon glyphicon-pencil" aria-hidden="true"></span>
            </button>
          </div>
        </div>
      )

    if @state.show_desc and not @props.activity.editing
      desc_elem = <div className="list-description">{@props.activity.description}</div>

    <div className='row activity'>
      {activity_elem}
      {desc_elem}
    </div>

module.exports = Activity