ActivitiesActionCreators = require '../actions/activities_actions'

ActivitiesAPI = Marty.createStateSource
  id: 'Activities'
  type: 'http'

  create: (activity) ->
    url = Routes.activities_path {format: 'json'}
    @post(
      url: url
      body: activity
    )
    .then (res) =>
      ActivitiesActionCreators.create_response res.body, res.ok
    .catch (err) ->
      ActivitiesActionCreators.create_response err.body, err.ok

  update: (activity) ->
    url = Routes.activity_path activity.id, {format: 'json'}
    @put(
      url: url
      body: activity
    )
    .then (res) =>
      ActivitiesActionCreators.update_response res.body, res.ok
    .catch (err) ->
      ActivitiesActionCreators.update_response err.body, err.ok
  

  delete: (activity) ->
    1

module.exports = ActivitiesAPI