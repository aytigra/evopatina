{div, span} = React.DOM
SectorGraph = React.createFactory require('./sector_graph')
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
        SectorGraph
          key: sector_id
          sector: AppStore.get_sector(sector_id)
          progress: AppStore.get_progress(sector_id)
          data: AppStore.get_sector_progress(sector_id)
          labels: labels
          redraw: @props.className


module.exports = Statistics;