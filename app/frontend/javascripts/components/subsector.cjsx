Activity = require './activity'

Subsector = React.createClass
  displayName: 'Subsector'
  render: ->
    activities = @props.activities.map (activity) ->
      <Activity key={activity.id} activity={activity}/>

    <div>
      <div className='row bg-info'>{@props.name}</div>
      <div>{activities}</div>
    </div>

module.exports = Subsector;