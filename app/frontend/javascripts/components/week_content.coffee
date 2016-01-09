{div} = React.DOM
WeeksStore = require '../stores/weeks_store'

WeekHeader = React.createFactory require('./week_header')
Sector = React.createFactory require('./sector')
SectorContent = React.createFactory require('./sector_content')
SectorStatistics = React.createFactory require('./sector_statistics')

WeekContent = React.createClass
  displayName: 'WeekContent'

  render: ->
    current_sector = WeeksStore.getCurrentSector()
    UI = WeeksStore.UI()

    sectors_class = ' col-xs-1'
    sector_content_class = ''
    stats_class = ' hidden-sm hidden-xs'

    if UI.show_sectors
      sectors_class = ' col-xs-12'
      sector_content_class = ' hidden-xs'

    if UI.show_stats
      sector_content_class = ' hidden-sm hidden-xs'
      stats_class = ' col-sm-7 col-xs-11'

    div id: 'week-content', className: 'row',
      WeekHeader
        week: WeeksStore.getCurrentWeek()
        UI: UI

      div
        className: 'sector-list col-lg-4 col-md-3 col-sm-5' + sectors_class
        _.map WeeksStore.getCurrentWeek().sectors, (sector_id) ->
          sector = WeeksStore.get_sector(sector_id)
          Sector
            key: sector.id, sector: sector
            current: sector.id == current_sector
            lapa_editing: UI.lapa_editing
            full: UI.show_sectors

      SectorContent
        className: 'sector-content col-lg-4 col-md-6 col-sm-7 col-xs-11' + sector_content_class
        sector: @props.sectors[current_sector]

      # SectorStatistics
      #   className: 'sector-statistics col-lg-4 col-md-3' + stats_class
      #   sector: @props.sectors[current_sector]
      #   show: UI.show_stats



module.exports = Marty.createContainer WeekContent,
  listenTo: [WeeksStore]
  fetch:
    sectors: ->
      WeeksStore.getSectors()
