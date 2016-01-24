{div, span} = React.DOM
PolarAreaChart = React.createFactory require("react-chartjs").PolarArea

ReactorStats = React.createClass
  displayName: 'ReactorStats'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.data isnt @props.data or
    newProps.redraw isnt @props.redraw

  render: ->
    data = _.map AppStore.get_day().sectors, (sector) ->
      value: AppStore.sector_status(sector),
      color: AppStore.get_sector(sector).color || "rgba(220,220,220,0.5)",
      label: AppStore.get_sector(sector).name

    div className: '',
      PolarAreaChart
        data: data
        options:
          tooltipTemplate: "<%= value %>%: <%=label%>"
          tooltipCaretSize: 0
          responsive: true
          animation: false
        redraw: true

module.exports = ReactorStats;