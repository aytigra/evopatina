{span} = React.DOM

Button = React.createClass
  displayName: 'Button'

  getDefaultProps: ->
    tag: 'button'
    id: null
    href: null
    type: null
    add_class: ''
    size: null
    color: null
    glyphicon: ''

  render: ->
    classname = ''
    ['size', 'color'].forEach (opt)=>
      if @props[opt] then classname += "btn-#{@props[opt]} "
    classname += @props.add_class

    React.DOM[@props.tag]
      id: @props.id
      href: @props.href
      type: @props.type
      className: "btn #{classname}"
      span
        className: "glyphicon glyphicon-#{@props.glyphicon}"
        'aria-hidden': "true"

module.exports = Button