weeksInit = require './weeks_init'
WeekContent = require './components/week_content'

Marty.HttpStateSource.addHook(
  priority: 1
  before: (req) ->
    req.headers['X-CSRF-Token'] = $('meta[name="csrf-token"]').attr('content')
)

$(document).on "ready page:change", ->
  # debug stores
  weeks = WeeksStore.getState()
  # recurcive load sectors <- subsectors <- activities
  sectors = SectorsStore.getSectors()
  
  # root react component
  React.render React.createElement(WeekContent, null), document.getElementById('week-content')

  $('[data-toggle="tooltip"]').tooltip({delay: { "show": 200, "hide": 100 }})