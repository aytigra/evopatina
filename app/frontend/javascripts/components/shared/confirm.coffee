Modal = require './modal'

Promise = $.Deferred
{div, button, h4} = React.DOM

Confirm = React.createClass
  displayName: 'Confirm'

  getDefaultProps: ->
    confirmLabel: 'OK'
    abortLabel: 'Cancel'

  abort: ->
    @promise.reject()

  _onKeyDown: (e) ->
    if e.keyCode is 27
      @abort()

  confirm: ->
    @promise.resolve()

  componentDidMount: ->
    @promise = new Promise()
    React.findDOMNode(@refs.confirm).focus()

  render: ->
    React.createElement Modal, null,
      div
        className: 'modal-header'
        h4 className: 'modal-title', @props.message
      if @props.description
        div
          className: 'modal-body'
          @props.description
      div
        className: 'modal-footer'
        div
          className: 'text-right'
          button
            role: 'abort'
            type: 'button'
            className: 'btn btn-default'
            onClick: @abort
            @props.abortLabel
          ' '
          button
            role: 'confirm'
            type: 'button'
            className: 'btn btn-primary'
            ref: 'confirm'
            onClick: @confirm
            autoFocus: true
            onKeyDown: @_onKeyDown
            @props.confirmLabel

module.exports = Confirm