{div, span} = React.DOM
ReactorStats = React.createFactory require('./statistics/reactor_stats')
RadarStats = React.createFactory require('./statistics/radar_stats')
DonutStats = React.createFactory require('./statistics/donut_stats')
moment = require("moment")
UIActionCreators = require '../actions/ui_actions'

Statistics = React.createClass
  displayName: 'Statistics'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.stats_ver isnt @props.stats_ver or
    newProps.className isnt @props.className or
    newProps.reactor_fragments_per_day isnt @props.reactor_fragments_per_day

  onFragmentsChange: (e) ->
    UIActionCreators.set_reactor_fragments_per_day(e.target.value)

  render: ->
    console.log @props.reactor_fragments_per_day
    div className: @props.className,
      div null,
        ReactorStats
          data: AppStore.state.progress
          redraw: @props.full
          fragments: @props.reactor_fragments_per_day
          on_fragments_change: @onFragmentsChange

      div null,
        RadarStats
          data: AppStore.state.progress
          redraw: @props.full

module.exports = Statistics;