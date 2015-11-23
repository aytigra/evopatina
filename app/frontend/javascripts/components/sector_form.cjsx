SectorsActionCreators = require '../actions/sectors_actions'
ItemErrorsBlock = require './item_errors_block'
ColorSelector = require './color_selector'

SectorForm = React.createClass
  displayName: 'SectorForm'

  propTypes:
    sector: React.PropTypes.object.isRequired

  _onNameChange: (e) ->
    params =
      name: e.target.value
    SectorsActionCreators.update_text @props.sector, params

  _onDescChange: (e) ->
    params =
      description: e.target.value
    SectorsActionCreators.update_text @props.sector, params

  _onSave: ->
    SectorsActionCreators.save @props.sector

  _onCancel: ->
    SectorsActionCreators.cancel @props.sector

  _onKeyDown: (e) ->
    if e.keyCode is 13
      @_onSave()
    if e.keyCode is 27
      @_onCancel()

  _onDelete: ->
    if not _.isEmpty(@props.sector.subsectors)
      react_confirm 'Will delete all nested subsectors and activities'
        .then =>
          SectorsActionCreators.destroy @props.sector

    else
      SectorsActionCreators.destroy @props.sector

  _onMove: (to) ->
    SectorsActionCreators.move @props.sector, to

  _onColorSelect: ->
    if window.support_color_input
      React.findDOMNode(this.refs.color_input).click()
    else
      react_modal ColorSelector, { color: @props.sector.color }
        .then (color) =>
          SectorsActionCreators.update @props.sector,
            color: color

  _onNativeColorSelect: (e) ->
    SectorsActionCreators.update @props.sector,
      color: e.target.value

  componentDidMount: ->
    #move cursor to the end of the text
    input = React.findDOMNode(this.refs.sector_input)
    length = input.value.length
    input.setSelectionRange(length, length)

  render: ->
    if @props.sector.have_errors
      errors_elem = <ItemErrorsBlock errors={@props.sector.errors} title='Server errors' />

    <div className='sector-form'>
      <div className='list-form-head'>
        <input
          id={'sector_' + @props.sector.id}
          ref='sector_input'
          placeholder='new sector'
          onChange={@_onNameChange}
          onKeyDown={@_onKeyDown}
          value={@props.sector.name}
          autoFocus={true}
        />
        <div className='btns-right'>
          <button onClick={@_onSave} className="btn btn-default btn-sm">
            <span className="glyphicon glyphicon-ok" aria-hidden="true"></span>
          </button>
          <button onClick={@_onCancel} className="btn btn-default btn-sm">
            <span className="glyphicon glyphicon-remove" aria-hidden="true"></span>
          </button>
        </div>
      </div>
      <div className='list-form-body'>
        <div className='btns-left'>
          <button onClick={@_onDelete} className="btn btn-default btn-sm">
            <span className="glyphicon glyphicon-trash" aria-hidden="true"></span>
          </button>
        </div>
        <textarea
          rows="3"
          placeholder="Description..."
          onChange={@_onDescChange}
          value={@props.sector.description}
        />
        <div className='btns-right'>
          <button onClick={@_onColorSelect} className="btn btn-default btn-sm">
            <span className="glyphicon glyphicon-adjust" aria-hidden="true"></span>
            <input type='color' onChange=@_onNativeColorSelect value={@props.sector.color}
              style={{opacity: '0', width: '100%'}}
              ref='color_input'/>
          </button>

          <button onClick={@_onMove.bind(@, 'up')} className="btn btn-default btn-sm">
            <span className="glyphicon glyphicon-chevron-up" aria-hidden="true"></span>
          </button>
          <button onClick={@_onMove.bind(@, 'down')} className="btn btn-default btn-sm">
            <span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span>
          </button>
        </div>
      </div>
      {errors_elem}
    </div>

module.exports = SectorForm