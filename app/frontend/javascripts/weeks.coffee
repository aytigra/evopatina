SectorsStore = require './stores/sectors_store'
SubsectorsStore = require './stores/subsectors_store'
ActivitiesStore = require './stores/activities_store'

WeekContent = require './components/week_content'
Confirm = require './components/shared/confirm'
SubsectorsSelector = require './components/selectors/subsectors_selector'
SectorGraph = require './components/statistics/activity_graph'

jstz = require 'jstimezonedetect'

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

window.select_subsector = (activity) ->
  props = { entry: activity, type: 'activity' }
  react_modal SubsectorsSelector, props

window.select_sector = (subsector) ->
  props = { entry: subsector, type: 'subsector' }
  react_modal SubsectorsSelector, props

$(document).on "ready, page:change", ->
  window.Cookies.set "timezone", jstz.determine().name(), { expires: 365, path: '/' }

  if week_container = document.getElementById('week-container')
    AppStore.setInitialState(DAY_JSON, true)

    # root react component
    React.render React.createElement(WeekContent, null), week_container

  if statistics_chart_container = document.getElementById('statistics-chart-container')
    statistics_chart = React.createElement SectorGraph,
      color: '#a0a'
      data: ACTIVITY_JSON

    React.render statistics_chart, statistics_chart_container