Activity = require './activity'

Subsector = React.createClass
  displayName: 'Subsector'
  render: ->
    activities = @props.activities.map (activity) ->
      <Activity key={activity.id} activity={activity}/>

    <div className='row bg-info'> @props.name </div>
    <div>{activities}</div>


module.exports = Subsector;