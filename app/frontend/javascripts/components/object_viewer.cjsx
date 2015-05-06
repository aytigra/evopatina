ObjectViewer = React.createClass
  displayName: 'ObjectViewer'

  render: ->
    lines = []
    for key, val of @props.obj
      if val isnt null
        if typeof val is 'object'
          Array.isArray(val)
          lines.push(
            <li key={key}>
              <p>{key}</p>
              <ObjectViewer obj={val} />
            </li>
          )
        else
          key_elem = null
          if not Array.isArray(@props.obj)
            key_elem = (
              <span>{key}:&nbsp;</span>
            )

          lines.push(
            <li key={key}>
              {key_elem}
              <span>{val}</span>
            </li>
          )


    <ul>
      {lines}
    </ul>

module.exports = ObjectViewer