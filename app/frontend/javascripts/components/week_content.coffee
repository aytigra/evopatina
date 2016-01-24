{div} = React.DOM

WeekHeader = React.createFactory require('./week_header')
Sector = React.createFactory require('./sector')
SectorContent = React.createFactory require('./sector_content')
Statistics = React.createFactory require('./statistics')

WeekContent = React.createClass
  displayName: 'WeekContent'

  render: ->
    current_sector = AppStore.getCurrentSector()
    UI = AppStore.UI()

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
        day: AppStore.get_day()
        UI: UI

      div
        className: 'sector-list col-lg-4 col-md-3 col-sm-5' + sectors_class
        _.map AppStore.get_day().sectors, (sector_id) ->
          sector = AppStore.get_sector(sector_id)
          Sector
            key: sector.id, sector: sector
            current: sector.id == current_sector
            full: UI.show_sectors

      SectorContent
        className: 'sector-content col-lg-4 col-md-6 col-sm-7 col-xs-11' + sector_content_class
        sector: AppStore.get_sector(current_sector)

      Statistics
        className: 'sector-statistics col-lg-4 col-md-3' + stats_class
        stats_ver: UI.stats_ver
        reactor_fragments_per_day: UI.reactor_fragments_per_day


module.exports = Marty.createContainer WeekContent,
  listenTo: [AppStore]
