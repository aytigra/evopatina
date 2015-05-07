SubsectorsActionCreators = require '../actions/subsectors_actions'
ItemErrorsBlock = require './item_errors_block'

SubsectorForm = React.createClass
  displayName: 'SubsectorForm'

  propTypes: 
    subsector: React.PropTypes.object.isRequired

  _onChange: (e) ->
    params =
      name: e.target.value
    SubsectorsActionCreators.update @props.subsector, params

  _onSave: ->
    SubsectorsActionCreators.save @props.subsector

  _onCancel: ->
    SubsectorsActionCreators.cancel @props.subsector

  _onDelete: ->
    if Object.keys(@props.subsector.activities).length
      if confirm 'Will delete all nested activities'
        SubsectorsActionCreators.destroy @props.subsector
    else
      SubsectorsActionCreators.destroy @props.subsector

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
            placeholder='new subsector'
            onChange={@_onChange}
            value={@props.subsector.name}
            autoFocus={true}
          />
          </div>
        <button onClick={@_onSave} className="btn btn-default btn-sm pull-right">
          <span className="glyphicon glyphicon-ok" aria-hidden="true"></span>
        </button>
        <button onClick={@_onCancel} className="btn btn-default btn-sm pull-right">
          <span className="glyphicon glyphicon-remove" aria-hidden="true"></span>
        </button>
      </div>
      {errors_elem}
    </div>

module.exports = SubsectorForm