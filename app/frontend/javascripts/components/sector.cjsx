Subsector = require './subsector'

Sector = React.createClass
  displayName: 'Sector'

  render: ->
    subsectors = []
    for id, subsector of @props.sector.subsectors
      subsectors.push(<Subsector key={id} subsector={subsector}/>)

    <div className='sector-content col-lg-2 col-md-4 col-sm-6 col-xs-12'>
      <div>{subsectors}</div>
    </div>

module.exports = Sector;