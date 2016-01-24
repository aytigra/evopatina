{div, span} = React.DOM
ReactorStats = React.createFactory require('./statistics/reactor_stats')
RadarStats = React.createFactory require('./statistics/radar_stats')
DonutStats = React.createFactory require('./statistics/donut_stats')
moment = require("moment")

Statistics = React.createClass
  displayName: 'Statistics'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.stats_ver isnt @props.stats_ver or
    newProps.className isnt @props.className

  render: ->
    div className: @props.className,
      div null,
        ReactorStats
          data: AppStore.state.progress
          redraw: @props.full

      div null,
        RadarStats
          data: AppStore.state.progress
          redraw: @props.full

module.exports = Statistics;