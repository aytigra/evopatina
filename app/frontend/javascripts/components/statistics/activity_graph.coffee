{div, span} = React.DOM
LineChart = React.createFactory require("react-chartjs").Line

ActivityGraph = React.createClass
  displayName: 'ActivityGraph'

  render: ->
    div
      className: 'activity-graph'
      style: { height: '300px' }
      LineChart
        data:
          labels: @props.data.labels
          datasets: [
            {
              label: 'Fragments'
              strokeColor: '#a0a'
              pointColor: '#a0a'
              pointStrokeColor: "#fff"
              pointHighlightFill: "#fff"
              pointHighlightStroke: "rgba(220,220,220,1)"
              data: @props.data.fragments
            }
            {
              label: 'Users'
              strokeColor: '#0a0'
              pointColor: '#0a0'
              pointStrokeColor: "#fff"
              pointHighlightFill: "#fff"
              pointHighlightStroke: "rgba(220,220,220,1)"
              data: @props.data.users
            }
          ]
        options:
          tooltipTemplate: "<%= value %> on <%=label%>"
          tooltipCaretSize: 0
          responsive: true
          maintainAspectRatio: false
          showScale: true
          scaleShowLabels: true
          animation: false
          legend: ['Fragments', 'Users']
          datasetFill:false

        redraw: true

module.exports = ActivityGraph;