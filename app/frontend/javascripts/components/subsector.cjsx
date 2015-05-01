Activity = require './activity'

Subsector = React.createClass
  displayName: 'Subsector'
  render: ->
    activities = []
    for id, activity of @props.subsector.activities
      activities.push(<Activity key={id} activity={activity}/>)
      
    <div>
      <div className='row bg-info'>{@props.subsector.name}</div>
      <div>{activities}</div>
    </div>

module.exports = Subsector;