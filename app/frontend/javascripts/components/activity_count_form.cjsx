ActivitiesActionCreators = require '../actions/activities_actions'
ItemErrorsBlock = require './item_errors_block'
EPutils = require '../ep_utils'

ActivityCountForm = React.createClass
  displayName: 'ActivityCountForm'

  propTypes: 
    activity: React.PropTypes.object.isRequired

  getInitialState: ->
    count: @props.activity.count || 0
    count_add: -1
    error: ''

  _onCountChange: (e) ->
    @setState
      count: EPutils.normalize_count e.target.value

  _onCountAddChange: (e) ->
    @setState
      count_add: EPutils.normalize_count e.target.value

  _onSave: ->
    count = parseFloat(@state.count) || 0
    count_add = parseFloat(@state.count_add) || 0
    count = EPutils.round(count + count_add, 2)
    if isNaN(count)
      @setState
        error: 'Not a number'
    else
      params =
        count: count
        edtitng_count: false
      ActivitiesActionCreators.update @props.activity, params


  _onCancel: ->
    ActivitiesActionCreators.cancel @props.activity

  _onKeyDown: (e) ->
    if e.keyCode is 13
      @_onSave()
    if e.keyCode is 27
      @_onCancel()

  componentDidMount: ->
    input = React.findDOMNode(this.refs.count_add_input)
    length = input.value.length
    input.setSelectionRange(0, length)

  render: ->
    if @state.error isnt ''
      errors_elem = <ItemErrorsBlock errors={{}} title='Not a number' />
    <div>
      <div>
        <div className='count_inputs'>
          <input
            ref='count_input'
            onChange={@_onCountChange}
            onKeyDown={@_onKeyDown}
            value={@state.count}
          />
          <label> + </label>
          <input
            ref='count_add_input'
            onChange={@_onCountAddChange}
            onKeyDown={@_onKeyDown}
            value={@state.count_add}
            autoFocus={true}
          />
          <label> fragment </label>
        </div>
        <button onClick={@_onCancel} className="btn btn-default btn-sm pull-right">
          <span className="glyphicon glyphicon-remove" aria-hidden="true"></span>
        </button>
        <button onClick={@_onSave} className="btn btn-default btn-sm pull-right">
          <span className="glyphicon glyphicon-ok" aria-hidden="true"></span>
        </button>
      </div>
      {errors_elem}
    </div>


module.exports = ActivityCountForm