{div, span} = React.DOM
Button = React.createFactory require('./button')
EPutils = require '../ep_utils'
LineChart = React.createFactory require("react-chartjs").Line

Statistics = React.createClass
  displayName: 'Statistics'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.sector isnt @props.sector && newProps.sector.id is @props.sector.id or
    newProps.className isnt @props.className

  render: ->
    labels =  _.map AppStore.get_day().days, (day) ->
      ''

    div className: @props.className,
      div style: { paddingLeft: '20px' },
        I18n.progress_history.replace '%{sector}', ''

      _.map AppStore.get_day().sectors, (sector_id) ->
        sector = AppStore.get_sector(sector_id)
        div style: { height: '100px' }, key: sector_id,
          div style: { paddingLeft: '20px' },
            sector.name
          LineChart
            data:
              labels: labels
              datasets: [
                label: "My First dataset",
                fillColor: sector.color || "rgba(220,220,220,0.2)"
                strokeColor: "rgba(220,220,220,1)",
                pointColor: "rgba(220,220,220,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(220,220,220,1)",
                data: AppStore.get_sector_progress(sector.id)
              ]
            options:
              responsive: true
              maintainAspectRatio: false
            redraw: true

module.exports = Statistics;