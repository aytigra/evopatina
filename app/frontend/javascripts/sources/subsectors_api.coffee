SubsectorsActionCreators = require '../actions/subsectors_actions'

SubsectorsAPI = Marty.createStateSource
  id: 'SubsectorsAPI'
  type: 'http'

  create: (subsector) ->
    url = Routes.subsectors_path {format: 'json'}
    @post(
      url: url
      body: subsector
    )
    .then (res) ->
      SubsectorsActionCreators.create_response res.body, res.ok

  update: (subsector) ->
    url = Routes.subsector_path subsector.id, {format: 'json'}
    @put(
      url: url
      body: subsector
    )
    .then (res) ->
      SubsectorsActionCreators.update_response res.body, res.ok
  

  destroy: (subsector) ->
    url = Routes.subsector_path subsector.id, {format: 'json'}
    @delete(
      url: url
      body: subsector
    )
    .then (res) ->
      SubsectorsActionCreators.destroy_response res.body, res.ok

module.exports = SubsectorsAPI