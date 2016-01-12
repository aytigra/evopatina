Modal = React.createFactory require('../shared/modal')
ColorPicker = React.createFactory require('react-color-picker')

Promise = $.Deferred
{div, button, h4} = React.DOM

ColorSelector = React.createClass
  displayName: 'ColorSelector'

  componentDidMount: ->
    @promise = new Promise()

  getInitialState: ->
    color: if @props.color then @props.color else "#fff"

  _onColorChange: (color)->
    @setState
      color: color

  _abort: ->
    @promise.reject()

  _choose: (to) ->
    @promise.resolve(@state.color)

  _onKeyDown: (e) ->
    if e.keyCode is 27
      @_abort()

  render: ->
    Modal null,
      div className: 'modal-header',
        h4 className: 'modal-title', "Select color"
        div className: 'modal-body modal-scrollable text-center',
          ColorPicker
            value: @state.color
            onChange: @_onColorChange
            onDrag: @_onColorChange
          div style: {background: @state.color, height: 20}

      div className: 'modal-footer',
        div className: 'text-right',
          button
            role: 'abort'
            type: 'button'
            className: 'btn btn-default'
            onClick: @_abort
            'Cancel'
          ' '
          button
            role: 'confirm'
            type: 'button'
            className: 'btn btn-primary'
            ref: 'confirm'
            onClick: @_choose
            autoFocus: true
            onKeyDown: @_onKeyDown
            'Ok'

module.exports = ColorSelector