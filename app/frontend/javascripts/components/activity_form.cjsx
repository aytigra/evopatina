ActivitiesActionCreators = require '../actions/activities_actions'
ItemErrorsBlock = require './item_errors_block'

ActivityForm = React.createClass
  displayName: 'ActivityForm'

  propTypes: 
    activity: React.PropTypes.object.isRequired

  _onNameChange: (e) ->
    params =
      name: e.target.value
    ActivitiesActionCreators.update_text @props.activity, params

  _onDescChange: (e) ->
    params =
      description: e.target.value
    ActivitiesActionCreators.update_text @props.activity, params

  _onSave: ->
    ActivitiesActionCreators.save @props.activity

  _onCancel: ->
    ActivitiesActionCreators.cancel @props.activity

  _onDelete: ->
    ActivitiesActionCreators.destroy @props.activity

  componentDidMount: ->
    input = React.findDOMNode(this.refs.activity_input)
    length = input.value.length
    input.setSelectionRange(length, length)

  render: ->
    if @props.activity.have_errors
      errors_elem = <ItemErrorsBlock errors={@props.activity.errors} title='Server errors' />

    <div>
      <div>
        <button onClick={@_onDelete} className="btn btn-default btn-sm pull-left">
          <span className="glyphicon glyphicon-trash" aria-hidden="true"></span>
        </button>
        <div className='activity_input'>
          <input
            id={'activity_' + @props.activity.id}
            ref='activity_input'
            placeholder='new activity'
            onChange={@_onNameChange}
            value={@props.activity.name}
            autoFocus={true}
          />
        </div>
        <button onClick={@_onCancel} className="btn btn-default btn-sm pull-right">
          <span className="glyphicon glyphicon-remove" aria-hidden="true"></span>
        </button>
        <button onClick={@_onSave} className="btn btn-default btn-sm pull-right">
          <span className="glyphicon glyphicon-ok" aria-hidden="true"></span>
        </button>
      </div>
      <div className='activity_textarea'>
        <textarea 
          rows="3"
          placeholder="Description..."
          onChange={@_onDescChange}
          value={@props.activity.description}
        />
      </div>
      {errors_elem}
    </div>


module.exports = ActivityForm