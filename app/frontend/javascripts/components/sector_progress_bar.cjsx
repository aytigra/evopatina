EPutils = require '../ep_utils'
WeeksStore = require '../stores/weeks_store'

SectorProgressBar = React.createClass
  displayName: 'SectorProgressBar'

  render: ->
    sector = @props.sector
    progress = sector.weeks[WeeksStore.getCurrentWeek().id].progress
    lapa = sector.weeks[WeeksStore.getCurrentWeek().id].lapa
    ratio = if progress > 0 && lapa > 0 then (progress/lapa) * 100 else 0
    <div className='row sector-progress'>
      <div className='progress'>
        <div className='progress-bar progress-bar-success' role='progressbar' style={{width: ratio + "%"}}>
          <div className='text-left text-muted'>{ EPutils.round(progress, 2) + '/' + lapa }</div>
        </div>
      </div>
    </div>

module.exports = SectorProgressBar;


