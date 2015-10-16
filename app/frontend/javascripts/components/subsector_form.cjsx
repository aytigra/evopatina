SubsectorsActionCreators = require '../actions/subsectors_actions'
ItemErrorsBlock = require './item_errors_block'

SubsectorForm = React.createClass
  displayName: 'SubsectorForm'

  propTypes:
    subsector: React.PropTypes.object.isRequired

  _onNameChange: (e) ->
    params =
      name: e.target.value
    SubsectorsActionCreators.update_text @props.subsector, params

  _onDescChange: (e) ->
    params =
      description: e.target.value
    SubsectorsActionCreators.update_text @props.subsector, params

  _onSave: ->
    SubsectorsActionCreators.save @props.subsector

  _onCancel: ->
    SubsectorsActionCreators.cancel @props.subsector

  _onKeyDown: (e) ->
    if e.keyCode is 13
      @_onSave()
    if e.keyCode is 27
      @_onCancel()

  _onDelete: ->
    if not _.isEmpty(@props.subsector.activities)
      react_confirm 'Will delete all nested activities'
        .then =>
          SubsectorsActionCreators.destroy @props.subsector

    else
      SubsectorsActionCreators.destroy @props.subsector

  _onMove: (to) ->
    SubsectorsActionCreators.move @props.subsector, to

  componentDidMount: ->
    #move cursor to the end of the text
    input = React.findDOMNode(this.refs.subsector_input)
    length = input.value.length
    input.setSelectionRange(length, length)

  render: ->
    if @props.subsector.have_errors
      errors_elem = <ItemErrorsBlock errors={@props.subsector.errors} title='Server errors' />

    <div className='subsector-form'>
      <div className='list-form-head'>
        <div className='btns-left'>
          <button onClick={@_onDelete} className="btn btn-default btn-sm pull-left">
            <span className="glyphicon glyphicon-trash" aria-hidden="true"></span>
          </button>
        </div>
        <input
          id={'subsector_' + @props.subsector.id}
          ref='subsector_input'
          placeholder='new subsector'
          onChange={@_onNameChange}
          onKeyDown={@_onKeyDown}
          value={@props.subsector.name}
          autoFocus={true}
        />
        <div className='btns-right'>
          <button onClick={@_onCancel} className="btn btn-default btn-sm pull-right">
            <span className="glyphicon glyphicon-remove" aria-hidden="true"></span>
          </button>
          <button onClick={@_onSave} className="btn btn-default btn-sm pull-right">
            <span className="glyphicon glyphicon-ok" aria-hidden="true"></span>
          </button>
        </div>
      </div>
      <div className='list-form-body'>
        <div className='btns-left'>
          <button onClick={@_onMove.bind(@, 'up')} className="btn btn-default btn-sm">
            <span className="glyphicon glyphicon-chevron-up" aria-hidden="true"></span>
          </button>
          <button onClick={@_onMove.bind(@, 'sector')} className="btn btn-default btn-sm">
            <span className="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
          </button>
          <button onClick={@_onMove.bind(@, 'down')} className="btn btn-default btn-sm">
            <span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span>
          </button>
        </div>
        <textarea
          rows="3"
          placeholder="Description..."
          onChange={@_onDescChange}
          value={@props.subsector.description}
        />
      </div>
      {errors_elem}
    </div>

module.exports = SubsectorForm