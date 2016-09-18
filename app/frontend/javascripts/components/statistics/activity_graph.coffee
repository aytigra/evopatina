{div, span, input, label} = React.DOM
LineChart = React.createFactory require("react-chartjs").Line

ActivityGraph = React.createClass
  displayName: 'ActivityGraph'

  getInitialState: ->
    dataset_show: [true, true, true]
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

  _onDatasetsChange: (e) ->
    dataset_show = @state.dataset_show
    dataset_show[e.target.value] = !@state.dataset_show[e.target.value]
    @setState dataset_show

  render: ->
    datasets_to_draw = @state.datasets.map (set, i) =>
      set if @state.dataset_show[i]

    div className: 'activity-graph',
      div className: 'activity-graph-controls',
        input { type: 'checkbox', name: 'dataset1', value: 0, checked: @state.dataset_show[0], onChange: @_onDatasetsChange }
        label { htmlFor: 'dataset1' }, @state.datasets[0].label
        input { type: 'checkbox', name: 'dataset2', value: 1, checked: @state.dataset_show[1], onChange: @_onDatasetsChange }
        label { htmlFor: 'dataset1' }, @state.datasets[1].label
        input { type: 'checkbox', name: 'dataset3', value: 2, checked: @state.dataset_show[2], onChange: @_onDatasetsChange }
        label { htmlFor: 'dataset1' }, @state.datasets[2].label

      div style: { height: '300px' },
        LineChart
          data:
            labels: @props.data.labels
            datasets: _.compact(datasets_to_draw)
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