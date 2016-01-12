{div, span} = React.DOM
LineChart = React.createFactory require("react-chartjs").Line

SectorGraph = React.createClass
  displayName: 'SectorGraph'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.progress isnt @props.progress or
    newProps.redraw isnt @props.redraw

  render: ->
    div className: 'chart-line toolbar',
      div className: 'btns-left', @props.sector.name
      LineChart
        data:
          labels: @props.labels
          datasets: [
            fillColor: @props.sector.color || "rgba(220,220,220,0.2)"
            strokeColor: "rgba(220,220,220,1)",
            pointColor: "rgba(220,220,220,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(220,220,220,1)",
            data: @props.data
          ]
        options:
          datasetStroke: false
          tooltipTemplate: "<%= value / 100 %>; <%=label%>"
          tooltipCaretSize: 0
          scaleFontSize: 0
          scaleShowHorizontalLines: false
          scaleShowVerticalLines: false
          responsive: true
          maintainAspectRatio: false
        redraw: true

module.exports = SectorGraph;