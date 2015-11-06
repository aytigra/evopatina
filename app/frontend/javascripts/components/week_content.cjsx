WeeksStore = require '../stores/weeks_store'

Button = require './button'
Sector = require './sector'
SectorContent = require './sector_content'

WeekContent = React.createClass
  displayName: 'WeekContent'

  render: ->
    week = WeeksStore.getCurrentWeek()
    sectors = []
    if current_sector = WeeksStore.getCurrentSector()
      for id, sector of @props.sectors
        current = sector.id == current_sector
        sectors.push(<Sector key={id} sector={sector} current={current}/>)
      sector_content = <SectorContent  key={current_sector} sector={@props.sectors[current_sector]} />
    else
      content_error = <div className='error'>something wrong with data, try to reload page</div>

    days = []
    week.days.forEach (day)->
      days.push(<span key={day['date']} className="label label-#{day['status']}">{day['name']}</span>)

    <div id='week-content' className='row'>

      <div className='row' id="week-header">
        <div className='text-center bg-success'>
          <a href={week.prev_path} id="prev-week-link">
            <Button size='small' glyphicon='arrow-left' add_class='pull-left'/>
          </a>

          {if week.next_path
            <a href={week.next_path} id="next-week-link">
              <Button size='small' glyphicon='arrow-right' add_class='pull-right'/>
            </a>
          }

          <span id='week-dates'>{week.begin_end_text}</span>
          {days}
        </div>
      </div>


      <div className='sector-list col-lg-3 col-md-6 col-sm-12 col-xs-12'>
        {sectors}
      </div>
      {sector_content}
      {content_error}
    </div>


module.exports = Marty.createContainer WeekContent,
  listenTo: [WeeksStore]
  fetch:
    sectors: ->
      WeeksStore.getSectors()

  pending: ->
    <div className="warning">
      <h4>loading...</h4>
    </div>
  failed: (errors)->
    <div className="warning">
      <h4>Error</h4>
    </div>