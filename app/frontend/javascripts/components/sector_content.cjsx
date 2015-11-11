{div} = React.DOM
Subsector = React.createFactory require('./subsector')
Button = React.createFactory require('./button')
SubsectorsActionCreators = require '../actions/subsectors_actions'
EPutils = require '../ep_utils'

SectorContent = React.createClass
  displayName: 'SectorContent'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.sector isnt @props.sector

  _onSubsectorCreate: ->
    SubsectorsActionCreators.create @props.sector

  render: ->
    div
      className: 'sector-content'
      EPutils.map_by_position @props.sector.subsectors, (subsector) ->
        if not subsector.hidden
          Subsector key: subsector.id, subsector: subsector,
      div className: 'row subsector-add',
        Button
          on_click: @_onSubsectorCreate
          size: 'sm'
          add_class: 'bg-info'
          glyphicon: 'plus'
          'add subsector'

module.exports = SectorContent;