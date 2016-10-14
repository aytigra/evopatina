{span} = React.DOM

Button = React.createClass
  displayName: 'Button'

  getDefaultProps: ->
    tag: 'button'
    add_class: ''
    active: false

  render: ->
    classname = ''
    ['size', 'color'].forEach (opt)=>
      if @props[opt] then classname += "btn-#{@props[opt]} "
    if @props.active then classname += 'active '
    classname += @props.add_class

    React.DOM[@props.tag]
      id: @props.id
      ref: @props.ref
      href: @props.href
      type: @props.type
      title: @props.title
      onClick: @props.on_click
      className: "btn #{classname}"
      if @props.glyphicon
        span
          className: "glyphicon glyphicon-#{@props.glyphicon}"
          'aria-hidden': "true"
      if @props.children
        span style: {marginLeft: '5px'},
          @props.children

module.exports = Button