weeksInit = require './weeks_init'
#WeekContainer = require './components/week_container'

$(document).on "ready page:change", ->
  weeks = WeeksStore.getState()
  sectors = SectorsStore.getState()
  subsectors = SubsectorsStore.getState()
  activities = ActivitiesStore.getState()
  #React.render React.createElement(WeekContainer, null, document.getElementById('sweek-container')

  $('[data-toggle="tooltip"]').tooltip({delay: { "show": 200, "hide": 100 }})