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

  _onKeyDown: (e) ->
    if e.keyCode is 13
      @_onSave()
    if e.keyCode is 27
      @_onCancel()

  _onDelete: ->
    ActivitiesActionCreators.destroy @props.activity

  _onMove: (to) ->
    ActivitiesActionCreators.move @props.activity, to

  componentDidMount: ->
    #move cursor to the end of the text
    input = React.findDOMNode(this.refs.activity_input)
    length = input.value.length
    input.setSelectionRange(length, length)

  render: ->
    if @props.activity.have_errors
      errors_elem = <ItemErrorsBlock errors={@props.activity.errors} title='Server errors' />

    <div className='activity-form'>
      <div className='list-form-head'>
        <div className='btns-left'>
          <button onClick={@_onDelete} className="btn btn-default btn-sm" title={I18n.delete}>
            <span className="glyphicon glyphicon-trash" aria-hidden="true"></span>
          </button>
        </div>
        <input
          id={'activity_' + @props.activity.id}
          ref='activity_input'
          placeholder={I18n.activity}
          onChange={@_onNameChange}
          onKeyDown={@_onKeyDown}
          value={@props.activity.name}
          autoFocus={true}
        />
        <div className='btns-right'>
          <button onClick={@_onSave} className="btn btn-default btn-sm" title={I18n.save}>
            <span className="glyphicon glyphicon-ok" aria-hidden="true"></span>
          </button>
          <button onClick={@_onCancel} className="btn btn-default btn-sm" title={I18n.cancel}>
            <span className="glyphicon glyphicon-remove" aria-hidden="true"></span>
          </button>
        </div>
      </div>
      <div className='list-form-body'>
        <textarea
          rows="4"
          placeholder={I18n.add + ' ' +I18n.description}
          onChange={@_onDescChange}
          value={@props.activity.description}
        />
        <div className='btns-right'>
          <button onClick={@_onMove.bind(@, 'up')} className="btn btn-default btn-sm" title={I18n.move_up}>
            <span className="glyphicon glyphicon-chevron-up" aria-hidden="true"></span>
          </button>
          <button onClick={@_onMove.bind(@, 'subsector')} className="btn btn-default btn-sm" title={I18n.move_to + ' ' + I18n.subsector}>
            <span className="glyphicon glyphicon-export" aria-hidden="true"></span>
          </button>
          <button onClick={@_onMove.bind(@, 'down')} className="btn btn-default btn-sm" title={I18n.move_down}>
            <span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span>
          </button>
        </div>
      </div>
      {errors_elem}
    </div>


module.exports = ActivityForm