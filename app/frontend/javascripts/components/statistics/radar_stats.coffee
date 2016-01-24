{div, span} = React.DOM
RadarChart = React.createFactory require("react-chartjs").Radar

RadarStats = React.createClass
  displayName: 'RadarStats'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.stats_ver isnt @props.stats_ver or
    newProps.redraw isnt @props.redraw

  render: ->
    labels = _.map AppStore.get_day().sectors, (sector) ->
      AppStore.get_sector(sector).name

    data = _.map AppStore.get_day().sectors, (sector) ->
      AppStore.sector_progress_sum(sector)

    div className: '',
      div className: 'stats-name text-center', I18n.stats.radar_title
      RadarChart
        data:
          labels: labels
          datasets: [
            fillColor: "rgba(220,220,220,0.2)"
            strokeColor: "rgba(220,220,220,1)",
            pointColor: "rgba(220,220,220,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(220,220,220,1)",
            data: data
          ]
        options:
          tooltipTemplate: "<%= value / 100 %>: <%=label%>"
          tooltipCaretSize: 0
          responsive: true
          animation: false
        redraw: true

module.exports = RadarStats;