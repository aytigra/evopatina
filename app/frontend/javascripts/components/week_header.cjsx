Button = require './button'
Sticky = require 'react-sticky'

WeekHeader = React.createClass
  displayName: 'WeekHeader'

  render: ->
    days = []
    @props.week.days.forEach (day)->
      days.push(<span key={day['date']} className="label label-#{day['status']}">{day['name']}</span>)

    <Sticky className='z-index-top'>
      <div className='navbar-default' id="week-header">
          <div className='week-navbar pull-right'>
            <div className='btns-left'>
              <Button tag='a' href={@props.week.prev_path} id="prev-week-link" glyphicon='arrow-left'/>
            </div>

            <div className='week-info'>
              <div className='week-dates'>{@props.week.begin_end_text}</div>
              <div>{days}</div>
            </div>

          {if @props.week.next_path
            <div className='btns-right'>
              <Button tag='a' href={@props.week.next_path} id="next-week-link" glyphicon='arrow-right'/>
            </div>
          }
          </div>

      </div>
    </Sticky>

module.exports = WeekHeader;