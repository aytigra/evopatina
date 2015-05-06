SubsectorsActionCreators = require '../actions/subsectors_actions'

SubsectorForm = React.createClass
  displayName: 'SubsectorForm'

  propTypes: 
    subsector: React.PropTypes.object.isRequired

  _onChange: (e) ->
    subsector = @props.subsector
    subsector.name = e.target.value
    SubsectorsActionCreators.update subsector

  _onSave: ->
    SubsectorsActionCreators.save @props.subsector

  _onCancel: ->
    SubsectorsActionCreators.cancel @props.subsector

  _onDelete: ->
    SubsectorsActionCreators.destroy @props.subsector

  render: ->
      if @props.subsector.have_errors
        errors_elem = (
          <div title={JSON.stringify(@props.subsector.errors)} className="pull-right text-danger">
            <span className="glyphicon glyphicon-alert" aria-hidden="true"></span>
          </div>
        )

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
        {errors_elem}
      </div>


module.exports = SubsectorForm