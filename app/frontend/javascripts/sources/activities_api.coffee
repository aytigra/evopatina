ActivitiesActionCreators = require '../actions/activities_actions'

ActivitiesAPI = Marty.createStateSource
  id: 'Activities'
  type: 'http'

  create: (activity) ->
    1

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