Activity = require './activity'
ActivitiesActionCreators = require '../actions/activities_actions'
SubsectorForm = require './subsector_form'
SubsectorsActionCreators = require '../actions/subsectors_actions'

Subsector = React.createClass
  displayName: 'Subsector'

  getInitialState: ->
    show_desc: false

  propTypes:
    subsector: React.PropTypes.object.isRequired

  shouldComponentUpdate: (newProps, newState) ->
    newProps.subsector isnt @props.subsector or newState isnt @state

  _onActivityCreate: (e) ->
    e.preventDefault()
    ActivitiesActionCreators.create @props.subsector

  _onEdit: (e) ->
    e.preventDefault()
    SubsectorsActionCreators.edit @props.subsector

  _showDescription: (e) ->
    @setState
      show_desc: !@state.show_desc


  render: ->
    activities = []
    have_hidden = false

    activities_ids = Object.keys(@props.subsector.activities)
    activities_ids.sort( (a, b) =>
     @props.subsector.activities[a].position - @props.subsector.activities[b].position
    )

    activities_ids.forEach (id) =>
      activity = @props.subsector.activities[id]
      activities.push(<Activity key={id} activity={activity}/>) if not activity.hidden

    if @props.subsector.editing
      subsector_elem = <SubsectorForm key={@props.subsector.id} subsector={@props.subsector}/>
    else
      subsector_elem = (
        <div>
          <label onClick={@_showDescription}>{@props.subsector.name}</label>
          <button onClick={@_onEdit}  className="btn btn-default btn-sm pull-right">
            <span className="glyphicon glyphicon-pencil" aria-hidden="true"></span>
          </button>
          <button onClick={@_onActivityCreate}  className="btn btn-default btn-sm pull-right">
            <span className="glyphicon glyphicon-plus" aria-hidden="true"></span>
          </button>
        </div>
      )

    if @state.show_desc and not @props.subsector.editing
      desc_elem = <div className="description">{@props.subsector.description}</div>

    <div>
      <div className='row subsector bg-info'>
        {subsector_elem}
        {desc_elem}
      </div>
      <div>{activities}</div>
    </div>

module.exports = Subsector;