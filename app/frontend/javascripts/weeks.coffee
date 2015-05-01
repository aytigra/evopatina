weeksInit = require './weeks_init'
WeekContainer = require './components/week_container'

$(document).on "ready page:change", ->
  # debug stores
  weeks = WeeksStore.getState()
  # recurcive load sectors <- subsectors <- activities
  sectors = SectorsStore.getSectors()
  
  # root react component
  React.render React.createElement(WeekContainer, null), document.getElementById('week-container')

  $('[data-toggle="tooltip"]').tooltip({delay: { "show": 200, "hide": 100 }})