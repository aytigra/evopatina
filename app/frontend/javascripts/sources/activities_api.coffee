ActivitiesActionCreators = require '../actions/activities_actions'

ActivitiesAPI = Marty.createStateSource
  id: 'ActivitiesAPI'
  type: 'http'

  create: (activity) ->
    url = Routes.activities_path {format: 'json'}
    @post(
      url: url
      body: activity
    )
    .then (res) ->
      ActivitiesActionCreators.create_response res.body, res.ok

  update: (activity) ->
    url = Routes.activity_path activity.id, {format: 'json'}
    @put(
      url: url
      body: activity
    )
    .then (res) ->
      ActivitiesActionCreators.update_response res.body, res.ok
  

  destroy: (activity) ->
    url = Routes.activity_path activity.id, {format: 'json'}
    @delete(
      url: url
      body: activity
    )
    .then (res) ->
      ActivitiesActionCreators.destroy_response res.body, res.ok

module.exports = ActivitiesAPI