SectorsStore = require './stores/sectors_store'
SubsectorsStore = require './stores/subsectors_store'
ActivitiesStore = require './stores/activities_store'

AppContent = require './components/app_content'
Confirm = require './components/shared/confirm'
SubsectorsSelector = require './components/selectors/subsectors_selector'
ActivityGraph = require './components/statistics/activity_graph'

jstz = require 'jstimezonedetect'
moment = require 'moment'

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

  current_day = moment(DAY_JSON.current_day.id, 'YYYYMMDD')
  window.DATEPICKER_OPTIONS =
    todayHighlight: true
    maxViewMode: 1
    orientation: 'bottom right'
    endDate: '0d'
    startDate: '-100d'
    defaultViewDate: { year: current_day.year(), month: current_day.month(), day: current_day.date() }

  if $('.sumary-datepicker-JS').length
    $('.sumary-datepicker-JS').datepicker(window.DATEPICKER_OPTIONS).on 'changeDate', (e) ->
      Turbolinks.visit('/summary/' + moment(e.date).format('DD-MM-YYYY'))

  if week_container = document.getElementById('week-container')
    AppStore.setInitialState(DAY_JSON, true)

    # root react component
    React.render React.createElement(AppContent, null), week_container

  if statistics_chart_container = document.getElementById('statistics-chart-container')
    statistics_chart = React.createElement ActivityGraph,
      color: '#a0a'
      data: ACTIVITY_JSON

    React.render statistics_chart, statistics_chart_container

  # reload page on the new day, if current day displayed
  window.onblur = ->
    window.onfocus = ->
      if window.location.pathname == '/' && DAY_JSON.current_day.id && DAY_JSON.current_day.id < moment().format('YYYYMMDD')
        location.reload(true)

$(document).on 'page:change', -> NProgress.done()
$(document).on 'page:restore', -> NProgress.remove()
