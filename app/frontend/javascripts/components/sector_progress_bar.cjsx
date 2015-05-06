SectorProgressBar = React.createClass
  displayName: 'SectorProgressBar'

  render: ->
    sector = @props.sector
    ratio = if sector.progress > 0 && sector.lapa > 0 then sector.progress/sector.lapa else 0
    <div className='row'>
      <div className={sector.icon + " hidden-lg pull-left"} aria-hidden="true"></div>
      <div className='progress'>
        <div className='progress-bar progress-bar-success' role='progressbar' style={{width: ratio + "%"}}>
          <div className='text-left text-muted'>{ sector.progress + '/' + sector.lapa }</div>
        </div>
      </div>
    </div>

module.exports = SectorProgressBar;

