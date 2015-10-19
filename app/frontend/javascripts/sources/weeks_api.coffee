WeeksActionCreators = require '../actions/weeks_actions'

WeeksAPI = Marty.createStateSource
  id: 'WeeksAPI'
  type: 'http'

  status: (res) ->
    if res.status not in [200,201,422]
      throw new Error("#{res.status}: #{res.statusText}")
    res

  get_week: (week_id) ->
    url = Routes.week_path week_id, {format: 'json'}
    @get url
    .then(@status)
    .then (res) ->
      WeeksActionCreators.get_week_response res.body, res.ok
    .catch (error) ->
      alert error


module.exports = WeeksAPI