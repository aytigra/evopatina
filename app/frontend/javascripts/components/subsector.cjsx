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
    have_hidden = false

    activities = _.map @props.subsector.activities, (id) ->
      activity = AppStore.get_activity(id)
      <Activity key={activity.id} activity={activity}/> if not activity.hidden

    if @props.subsector.editing
      subsector_elem = <SubsectorForm key={@props.subsector.id} subsector={@props.subsector}/>
    else
      subsector_elem = (
        <div className='list-name' title={@props.subsector.description}>
          <label onClick={@_showDescription}>{@props.subsector.name}</label>
          <div className='btns-right'>
            <button onClick={@_onActivityCreate}  className="btn btn-default btn-sm" title={I18n.subsectors.add_activity}>
              <span className="glyphicon glyphicon-plus" aria-hidden="true"></span>
            </button>
            <button onClick={@_onEdit}  className="btn btn-default btn-sm" title={I18n.subsectors.edit}>
              <span className="glyphicon glyphicon-pencil" aria-hidden="true"></span>
            </button>
          </div>
        </div>
      )

    if @state.show_desc and not @props.subsector.editing
      desc_elem = <div className="list-description">{@props.subsector.description}</div>

    <div>
      <div className='row subsector bg-info'>
        {subsector_elem}
        {desc_elem}
      </div>
      <div>{activities}</div>
    </div>

module.exports = Subsector;