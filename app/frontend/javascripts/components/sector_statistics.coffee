{div, span} = React.DOM
SectorProgressBar = React.createFactory require('./sector_progress_bar')
EPutils = require '../ep_utils'

SectorStatistics = React.createClass
  displayName: 'SectorStatistics'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.sector isnt @props.sector

  render: ->
    div className: 'sector-statistics',
      div null,
        'progress history for "' + @props.sector.name + '"'

      EPutils.map_by_position @props.sector.weeks, (week, id) ->
        SectorProgressBar key: id, data: week

module.exports = SectorStatistics;