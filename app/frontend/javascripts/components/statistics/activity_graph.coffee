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
              label: I18n.my_fragments
              strokeColor: '#2ecc71'
              pointColor: '#2ecc71'
              pointStrokeColor: "#fff"
              pointHighlightFill: "#fff"
              pointHighlightStroke: "rgba(220,220,220,1)"
              data: @props.data.my_fragments
            }
            {
              label: I18n.all_fragments
              strokeColor: '#f1c40f'
              pointColor: '#f1c40f'
              pointStrokeColor: "#fff"
              pointHighlightFill: "#fff"
              pointHighlightStroke: "rgba(220,220,220,1)"
              data: @props.data.fragments
            }
            {
              label: I18n.users
              strokeColor: '#3498db'
              pointColor: '#3498db'
              pointStrokeColor: "#fff"
              pointHighlightFill: "#fff"
              pointHighlightStroke: "rgba(220,220,220,1)"
              data: @props.data.users
            }
          ]
        options:
          tooltipCaretSize: 0
          responsive: true
          maintainAspectRatio: false
          showScale: true
          scaleShowLabels: true
          animation: false
          datasetFill:false

        redraw: true

module.exports = ActivityGraph;