ObjectViewer = require './object_viewer'

ItemErrorsBlock = React.createClass
  displayName: 'ItemErrorsBlock'

  getInitialState: ->
    show_errors: false

  propTypes:
    errors: React.PropTypes.object.isRequired
    title: React.PropTypes.string



  render: ->
    if not _.isEmpty(@props.errors)
      errors_block = <ObjectViewer obj={@props.errors} />
    else
      errors_block = null

    <div className="text-danger errors_block">
      <div className="errors_block_title">
        <span className="glyphicon glyphicon-alert" aria-hidden="true"></span>
        <span>&nbsp;</span>
        <span>{@props.title}</span>
      </div>
      <div className="errors_block_body">
        {errors_block}
      </div>
    </div>


module.exports = ItemErrorsBlock