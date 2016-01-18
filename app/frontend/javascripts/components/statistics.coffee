{div, span} = React.DOM
SectorGraph = React.createFactory require('./sector_graph')
moment = require("moment")

Statistics = React.createClass
  displayName: 'Statistics'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.stats_ver isnt @props.stats_ver or
    newProps.className isnt @props.className

  render: ->
    div className: @props.className,
      div className: 'stats-title',
        I18n.stats.reactor_title

      div null,
        'coming soon'

module.exports = Statistics;