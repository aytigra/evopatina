{div} = React.DOM
WeeksStore = require '../stores/weeks_store'

WeekHeader = React.createFactory require('./week_header')
Sector = React.createFactory require('./sector')
SectorContent = React.createFactory require('./sector_content')
SectorStatistics = React.createFactory require('./sector_statistics')

EPutils = require '../ep_utils'

WeekContent = React.createClass
  displayName: 'WeekContent'

  render: ->
    week = WeeksStore.getCurrentWeek()
    current_sector = WeeksStore.getCurrentSector()

    sectors_class = ' col-xs-1'
    sector_content_class = ''
    stats_class = ' hidden-sm hidden-xs'

    if WeeksStore.get_settings().show_sectors
      sectors_class = ' col-xs-12'
      sector_content_class = ' hidden-xs'

    if WeeksStore.get_settings().show_stats
      sector_content_class = ' hidden-sm hidden-xs'
      stats_class = ' col-sm-7 col-xs-11'

    div id: 'week-content', className: 'row',
      WeekHeader week: week

      div
        className: 'sector-list col-lg-4 col-md-3 col-sm-5' + sectors_class
        EPutils.map_by_position @props.sectors, (sector, id) ->
          Sector
            key: id, sector: sector
            current: sector.id == current_sector
            lapa_editing: week.lapa_editing
            full: WeeksStore.get_settings().show_sectors

      div
        className: 'col-lg-4 col-md-6 col-sm-7 col-xs-11' + sector_content_class
        SectorContent sector: @props.sectors[current_sector]

      div
        className: 'col-lg-4 col-md-3' + stats_class
        SectorStatistics
          sector: @props.sectors[current_sector]
          show: WeeksStore.get_settings().show_stats



module.exports = Marty.createContainer WeekContent,
  listenTo: [WeeksStore]
  fetch:
    sectors: ->
      WeeksStore.getSectors()