{button, span} = React.DOM

Button = React.createClass
  displayName: 'Button'

  getDefaultProps: ->
    size: 'normal'
    add_class: ''
    glyphicon: ''

  render: ->
    button
      className: "btn btn-#{@props.size} #{@props.add_class}"
      span
        className: "glyphicon glyphicon-#{@props.glyphicon}"
        'aria-hidden': "true"

module.exports = Button