{div} = React.DOM

Modal = React.createClass
  displayName: 'Modal'

  backdrop: ->
    div
      className: 'modal-backdrop in'

  modal: ->
    div
      className: 'modal in'
      tabIndex: -1
      role: 'dialog'
      'aria-hidden': false
      ref: 'modal'
      style:
        display: 'block'
      div
        className: 'modal-dialog'
        div
          className: 'modal-content'
          @props.children

  render: ->
    div null,
      @backdrop()
      @modal()

module.exports = Modal