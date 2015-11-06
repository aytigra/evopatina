EPutils = require '../ep_utils'
WeeksStore = require '../stores/weeks_store'

SectorHeader = React.createClass
  displayName: 'SectorHeader'

  render: ->
    sector = @props.sector
    status = EPutils.sector_status_icon(sector.weeks[WeeksStore.getCurrentWeek().id])

    <div className="sector-header">
      <div className="sector-icon pull-left">
        <span className={sector.icon + ""} aria-hidden="true"></span>
      </div>
      <div className="sector-status pull-left">
        <span className={"glyphicon glyphicon-#{status}"} aria-hidden="true"></span>
      </div>
      <div className="sector-name">
        <span>{sector.name}</span>
      </div>
    </div>

module.exports = SectorHeader;