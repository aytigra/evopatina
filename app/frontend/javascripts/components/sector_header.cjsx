SectorHeader = React.createClass
  displayName: 'SectorHeader'

  render: ->
    sector = @props.sector
    status = "triangle-top"
    if sector.progress*1 is 0  
      status = "triangle-bottom"
    if sector.progress >= sector.lapa && sector.lapa*1 isnt 0
      status = "arrow-up"
    <div className="row sector-header">
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