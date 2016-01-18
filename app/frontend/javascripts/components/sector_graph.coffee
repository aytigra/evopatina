{div, span} = React.DOM
LineChart = React.createFactory require("react-chartjs").Line

SectorGraph = React.createClass
  displayName: 'SectorGraph'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.progress isnt @props.progress or
    newProps.redraw isnt @props.redraw

  render: ->
    div className: 'sector-graph',
      LineChart
        data:
          labels: @props.labels
          datasets: [
            fillColor: @props.color || "rgba(220,220,220,0.2)"
            strokeColor: @props.color || "rgba(220,220,220,1)",
            pointColor: @props.color || "rgba(220,220,220,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(220,220,220,1)",
            data: @props.data
          ]
        options:
          tooltipTemplate: "<%= value / 100 %> on <%=label%>"
          tooltipCaretSize: 0
          responsive: true
          maintainAspectRatio: false
          showScale: false
          animation: false
        redraw: true

module.exports = SectorGraph;