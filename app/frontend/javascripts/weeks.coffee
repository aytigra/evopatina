WeeksStore = require './stores/weeks_store'
SectorsStore = require './stores/sectors_store'
SubsectorsStore = require './stores/subsectors_store'
ActivitiesStore = require './stores/activities_store'

WeekContent = require './components/week_content'
Confirm = require './components/confirm'
SubsectorsSelector = require './components/subsectors_selector'

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


color_input = document.createElement('input')
color_input.setAttribute("type", "color");
window.support_color_input = color_input.type != 'text'

window.react_modal = (Component, props) ->
  wrapper = document.body.appendChild(document.createElement('div'))
  component = React.render(React.createElement(Component, props), wrapper)
  $("body").addClass("modal-open")
  cleanup = ->
    React.unmountComponentAtNode(wrapper)
    setTimeout -> wrapper.remove()
    $("body").removeClass("modal-open")
  component.promise.always(cleanup).promise()

window.react_confirm = (message, options = {}) ->
  props = $.extend({message: message}, options)
  react_modal Confirm, props

window.select_subsector = (activity, sectors) ->
  props = { entry: activity, sectors: sectors, type: 'activity' }
  react_modal SubsectorsSelector, props

window.select_sector = (subsector, sectors) ->
  props = { entry: subsector, sectors: sectors, type: 'subsector' }
  react_modal SubsectorsSelector, props

$(document).on "ready, page:change", ->
  if week_container = document.getElementById('week-container')
    WeeksStore.setInitialState(WEEK_JSON, true)

    # root react component
    React.render React.createElement(WeekContent, null), week_container