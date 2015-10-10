WeeksStore = require './stores/weeks_store'
SectorsStore = require './stores/sectors_store'
SubsectorsStore = require './stores/subsectors_store'
ActivitiesStore = require './stores/activities_store'

WeekContent = require './components/week_content'
Confirm = require './components/confirm'

Marty.HttpStateSource.addHook(
  priority: 1
  before: (req) ->
    req.headers['X-CSRF-Token'] = $('meta[name="csrf-token"]').attr('content')
    NProgress.start()
  after: (req) ->
    NProgress.done()
    if req.status in [200, 201] 
      req.ok ||= true 
      req.body.errors ||= {}
    else if req.status is 422
      req.ok ||= false 
      req.body.errors ||= {}
    req
)

window.react_confirm = (message, options = {}) ->
  props = $.extend({message: message}, options)
  wrapper = document.body.appendChild(document.createElement('div'))
  component = React.render(React.createElement(Confirm, props), wrapper)
  cleanup = ->
    React.unmountComponentAtNode(wrapper)
    setTimeout -> wrapper.remove()
  component.promise.always(cleanup).promise()

$(document).on "ready page:change", ->
  # root react component
  React.render React.createElement(WeekContent, null), document.getElementById('week-content')

  WeeksStore.loadWeek(window.location.pathname.split('/').pop())

  $('[data-toggle="tooltip"]').tooltip({delay: { "show": 200, "hide": 100 }}) 