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

  _onDelete: ->
    if Object.keys(@props.subsector.activities).length
      react_confirm 'Will delete all nested activities'
        .then =>
          SubsectorsActionCreators.destroy @props.subsector
        
    else
      SubsectorsActionCreators.destroy @props.subsector

  componentDidMount: ->
    input = React.findDOMNode(this.refs.subsector_input)
    length = input.value.length
    input.setSelectionRange(length, length)

  render: ->
    if @props.subsector.have_errors
      errors_elem = <ItemErrorsBlock errors={@props.subsector.errors} title='Server errors' />

    <div>
      <div>
        <button onClick={@_onDelete} className="btn btn-default btn-sm pull-left">
          <span className="glyphicon glyphicon-trash" aria-hidden="true"></span>
        </button>
        <div className='subsector_input'>
          <input
            id={'subsector_' + @props.subsector.id}
            ref='subsector_input'
            placeholder='new subsector'
            onChange={@_onNameChange}
            value={@props.subsector.name}
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
      <div className='subsector_textarea'>
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