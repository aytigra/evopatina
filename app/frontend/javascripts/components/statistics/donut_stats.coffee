{div, span} = React.DOM
DonutChart = React.createFactory require("react-chartjs").Doughnut

DonutStats = React.createClass
  displayName: 'DonutStats'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.data isnt @props.data or
    newProps.redraw isnt @props.redraw

  render: ->
    data = _.map AppStore.get_day().sectors, (sector) ->
      value: AppStore.sector_progress_sum(sector),
      color: AppStore.get_sector(sector).color || "rgba(220,220,220,0.5)",
      label: AppStore.get_sector(sector).name

    div className: '',
      DonutChart
        data: data
        options:
          tooltipTemplate: "<%= value / 100 %>: <%=label%>"
          tooltipCaretSize: 0
          responsive: true
          animation: false
        redraw: true

module.exports = DonutStats;