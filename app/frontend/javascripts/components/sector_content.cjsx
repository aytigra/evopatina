{div} = React.DOM
Subsector = React.createFactory require('./subsector')
Button = React.createFactory require('./button')
SubsectorsActionCreators = require '../actions/subsectors_actions'
EPutils = require '../ep_utils'

SectorContent = React.createClass
  displayName: 'SectorContent'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.sector isnt @props.sector or
    newProps.show isnt @props.show

  _onSubsectorCreate: ->
    SubsectorsActionCreators.create @props.sector

  render: ->
    div
      className: 'sector-content col-lg-4 col-md-6 col-sm-7 col-xs-11 ' + if @props.show then '' else 'hidden'
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