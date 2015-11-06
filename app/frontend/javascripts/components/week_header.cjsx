Button = require './button'
Sticky = require 'react-sticky'

WeekHeader = React.createClass
  displayName: 'WeekHeader'

  render: ->
    days = []
    @props.week.days.forEach (day)->
      days.push(<span key={day['date']} className="label label-#{day['status']}">{day['name']}</span>)

    <Sticky className={'z-index-top'}>
      <div className='text-center bg-success' id="week-header">
          <a href={@props.week.prev_path} id="prev-week-link">
            <Button size='small' glyphicon='arrow-left' add_class='pull-left'/>
          </a>

          {if @props.week.next_path
            <a href={@props.week.next_path} id="next-week-link">
              <Button size='small' glyphicon='arrow-right' add_class='pull-right'/>
            </a>
          }

          <span id='week-dates'>{@props.week.begin_end_text}</span>
          {days}
      </div>
    </Sticky>

module.exports = WeekHeader;