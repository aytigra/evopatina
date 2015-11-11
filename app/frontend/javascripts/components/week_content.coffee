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
    xs_sectors_width = if WeeksStore.get_settings().show_sectors then 'col-xs-12' else 'col-xs-1'

    div id: 'week-content', className: 'row',
      WeekHeader week: week

      div
        className: 'sector-list col-lg-4 col-md-3 col-sm-5 ' + xs_sectors_width
        EPutils.map_by_position @props.sectors, (sector, id) ->
          Sector
            key: id, sector: sector
            current: sector.id == current_sector
            lapa_editing: week.lapa_editing
            full: WeeksStore.get_settings().show_sectors

      SectorContent
        sector: @props.sectors[current_sector]
        show: !( WeeksStore.get_settings().show_sectors || WeeksStore.get_settings().show_stats )

      SectorStatistics
        sector: @props.sectors[current_sector]
        show: WeeksStore.get_settings().show_stats



module.exports = Marty.createContainer WeekContent,
  listenTo: [WeeksStore]
  fetch:
    sectors: ->
      WeeksStore.getSectors()

  pending: ->
    <div className="warning">
      <h4>loading...</h4>
    </div>
  failed: (errors)->
    <div className="warning">
      <h4>Error</h4>
    </div>