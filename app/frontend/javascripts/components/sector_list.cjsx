Subsector = require './subsector'

SectorList = React.createClass
  displayName: 'SectorList'
  render: ->
    subsectors = @props.subsectors.map (subsector) ->
      <Subsector key={subsector.id} name={subsector.name} activities={subsector.activities} />

    <div>{subsectors}</div>

module.exports = SectorList;