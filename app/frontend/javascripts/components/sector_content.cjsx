{div} = React.DOM
Subsector = React.createFactory require('./subsector')
Button = React.createFactory require('./button')
SubsectorsActionCreators = require '../actions/subsectors_actions'
EPutils = require '../ep_utils'

SectorContent = React.createClass
  displayName: 'SectorContent'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.sector isnt @props.sector or
    newProps.shown_sectors isnt @props.shown_sectors or
    newProps.shown_stats isnt @props.shown_stats

  _onSubsectorCreate: ->
    SubsectorsActionCreators.create @props.sector

  render: ->
    class_name = 'sector-content col-lg-4 col-md-6 col-sm-7 col-xs-11 '
    if @props.shown_stats
      class_name += ' hidden-sm'
    if @props.shown_sectors
      class_name += ' hidden-xs'

    div
      className: class_name
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