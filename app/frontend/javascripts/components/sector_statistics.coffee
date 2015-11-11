{div, span} = React.DOM
SectorProgressBar = React.createFactory require('./sector_progress_bar')
EPutils = require '../ep_utils'

SectorStatistics = React.createClass
  displayName: 'SectorStatistics'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.sector isnt @props.sector or
    newProps.current isnt @props.current or
    newProps.show isnt @props.show

  render: ->
    class_name = "sector-statistics col-lg-4 col-md-3 "
    class_name += if @props.show then 'col-sm-7 col-xs-11' else 'hidden-sm hidden-xs'
    div className: class_name,
      div null,
        'progress history for "' + @props.sector.name + '"'

      EPutils.map_by_position @props.sector.weeks, (week, id) ->
        SectorProgressBar key: id, data: week

module.exports = SectorStatistics;