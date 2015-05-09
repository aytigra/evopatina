ObjectViewer = require './object_viewer'

ItemErrorsBlock = React.createClass
  displayName: 'ItemErrorsBlock'

  getInitialState: ->
    show_errors: false

  propTypes: 
    errors: React.PropTypes.object.isRequired
    title: React.PropTypes.string

  _onClick: (e) ->
    @setState
      show_errors: !@state.show_errors


  render: ->
    if @state.show_errors && Object.keys(@props.errors).length
      errors_block = <ObjectViewer obj={@props.errors} />
      toggle_icon = 'up'
    else
      errors_block = null
      toggle_icon = 'down'

    <div className="text-danger errors_block">
      <div onClick={@_onClick} className="errors_block_title">
        <span className="glyphicon glyphicon-alert" aria-hidden="true"></span>
        <span>&nbsp;</span>
        <span>{@props.title}</span>
        <div className="pull-right">
          <span className="glyphicon glyphicon-chevron-#{toggle_icon}" aria-hidden="true"></span>
        </div>
      </div>
      <div className="errors_block_body">
        {errors_block}
      </div>
    </div>


module.exports = ItemErrorsBlock