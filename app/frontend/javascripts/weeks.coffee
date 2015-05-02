weeksInit = require './weeks_init'
WeekContent = require './components/week_content'

$(document).on "ready page:change", ->
  # debug stores
  weeks = WeeksStore.getState()
  # recurcive load sectors <- subsectors <- activities
  sectors = SectorsStore.getSectors()
  
  # root react component
  React.render React.createElement(WeekContent, null), document.getElementById('week-content')

  $('[data-toggle="tooltip"]').tooltip({delay: { "show": 200, "hide": 100 }})