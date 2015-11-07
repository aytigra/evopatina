Button = require './button'
Sticky = require 'react-sticky'
WeeksActionCreators = require '../actions/weeks_actions'

WeekHeader = React.createClass
  displayName: 'WeekHeader'

  _onEditLapa: ->
    WeeksActionCreators.edit_lapa @props.week

  render: ->
    days = []
    @props.week.days.forEach (day)->
      days.push(<span key={day['date']} className="label label-#{day['status']}">{day['name']}</span>)
    lapa_editing_class = if @props.week.lapa_editing then 'active' else ''

    <Sticky className='z-index-top'>
      <div className='navbar-default' id="week-header">
          <Button on_click={@_onEditLapa} tag='button' glyphicon='cog' add_class={lapa_editing_class} title='edit lapa'/>

          <div className='week-navbar pull-right'>
            <div className='btns-left'>
              <Button tag='a' href={@props.week.prev_path} id="prev-week-link" glyphicon='arrow-left' title='go to previous week'/>
            </div>

            <div className='week-info'>
              <div className='week-dates'>{@props.week.begin_end_text}</div>
              <div>{days}</div>
            </div>

          {if @props.week.next_path
            <div className='btns-right'>
              <Button tag='a' href={@props.week.next_path} id="next-week-link" glyphicon='arrow-right' title='go to next week'/>
            </div>
          }
          </div>

      </div>
    </Sticky>

module.exports = WeekHeader;