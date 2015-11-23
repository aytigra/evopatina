{div} = React.DOM
Subsector = React.createFactory require('./subsector')
Button = React.createFactory require('./button')
SubsectorsActionCreators = require '../actions/subsectors_actions'
EPutils = require '../ep_utils'

SectorContent = React.createClass
  displayName: 'SectorContent'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.sector isnt @props.sector or
    newProps.className isnt @props.className

  _onSubsectorCreate: ->
    SubsectorsActionCreators.create @props.sector

  render: ->
    div
      className: @props.className
      EPutils.map_by_position @props.sector.subsectors, (subsector) ->
        if not subsector.hidden
          Subsector key: subsector.id, subsector: subsector,
      div className: 'row subsector-add',
        Button
          on_click: @_onSubsectorCreate
          size: 'sm'
          add_class: 'bg-info'
          glyphicon: 'plus'
          tytle: I18n.add + ' ' + I18n.subsector
          I18n.add + ' ' + I18n.subsector_abbr

module.exports = SectorContent;