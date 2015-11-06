EPutils = require '../ep_utils'

SectorProgressBar = React.createClass
  displayName: 'SectorProgressBar'

  render: ->
    data = @props.data
    progress = @props.data.progress
    lapa = @props.data.lapa
    ratio = if progress > 0 && lapa > 0 then (progress/lapa) * 100 else 0
    <div className='sector-progress'>
      <div className='progress'>
        <div className='progress-bar progress-bar-success' role='progressbar' style={{width: ratio + "%"}}>
          <div className='text-left text-muted'>{ EPutils.round(progress, 2) + '/' + lapa }</div>
        </div>
      </div>
    </div>

module.exports = SectorProgressBar;


