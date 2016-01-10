{div, span} = React.DOM
Button = React.createFactory require('./button')
EPutils = require '../ep_utils'
LineChart = React.createFactory require("react-chartjs").Line
moment = require("moment")

Statistics = React.createClass
  displayName: 'Statistics'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.stats_ver isnt @props.stats_ver or
    newProps.className isnt @props.className

  render: ->
    labels =  _.map AppStore.get_day().days, (day) ->
      moment(day, "YYYYMMDD").format('DD-MM-YYYY')

    div className: @props.className,
      div className: 'stats-title',
        I18n.progress_history.replace '%{sector}', ''

      _.map AppStore.get_day().sectors, (sector_id) =>
        sector = AppStore.get_sector(sector_id)
        redraw = AppStore.UI().show_stats || @props.sector.id == sector.id
        div
          key: sector_id
          className: 'chart-line toolbar'
          div className: 'btns-left', sector.name
          LineChart
            data:
              labels: labels
              datasets: [
                fillColor: sector.color || "rgba(220,220,220,0.2)"
                strokeColor: "rgba(220,220,220,1)",
                pointColor: "rgba(220,220,220,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(220,220,220,1)",
                data: AppStore.get_sector_progress(sector.id)
              ]
            options:
              tooltipTemplate: "<%= value %>; <%=label%>"
              tooltipCaretSize: 0
              scaleFontSize: 0
              scaleShowHorizontalLines: false
              scaleShowVerticalLines: false
              responsive: true
              maintainAspectRatio: false
            redraw: redraw



module.exports = Statistics;