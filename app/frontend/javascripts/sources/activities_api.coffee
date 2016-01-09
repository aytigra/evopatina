ActivitiesActionCreators = require '../actions/activities_actions'

ActivitiesAPI = Marty.createStateSource
  id: 'ActivitiesAPI'
  type: 'http'

  status: (res) ->
    if res.status not in [200,201,422]
      throw new Error("#{res.status}: #{res.statusText}")
    res

  create: (activity) ->
    url = Routes.activities_path {format: 'json'}
    @post(
      url: url
      body: activity
    )
    .then(@status)
    .then (res) ->
      ActivitiesActionCreators.create_response res.body, res.ok
    .catch (error) ->
      alert error

  update: (activity) ->
    url = Routes.activity_path activity.id, {format: 'json'}
    @put(
      url: url
      body: activity
    )
    .then(@status)
    .then (res) ->
      ActivitiesActionCreators.update_response res.body, res.ok
    .catch (error) ->
      alert error

  update_count: (activity, day_id) ->
    url = Routes.fragment_path activity.id, {format: 'json'}
    @put(
      url: url
      body:
        count: activity.count
        day_id: day_id
    )
    .then(@status)
    .then (res) ->
      ActivitiesActionCreators.update_count_response res.body, res.ok
    .catch (error) ->
      alert error

  destroy: (activity) ->
    url = Routes.activity_path activity.id, {format: 'json'}
    @delete(
      url: url
      body: activity
    )
    .then(@status)
    .then (res) ->
      ActivitiesActionCreators.destroy_response res.body, res.ok
    .catch (error) ->
      alert error

  move: (activity, to) ->
    url = Routes.move_activity_path activity.id, {format: 'json'}
    @put(
      url: url
      body: {subsector_id: activity.subsector_id, to: to}
    )
    .then(@status)
    .then (res) ->
      ActivitiesActionCreators.move_response res.body, res.ok
    .catch (error) ->
      alert error

module.exports = ActivitiesAPI