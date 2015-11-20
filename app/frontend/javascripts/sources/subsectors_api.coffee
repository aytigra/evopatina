SubsectorsActionCreators = require '../actions/subsectors_actions'

SubsectorsAPI = Marty.createStateSource
  id: 'SubsectorsAPI'
  type: 'http'

  status: (res) ->
    if res.status not in [200,201,422]
      throw new Error("#{res.status}: #{res.statusText}")
    res

  create: (subsector) ->
    url = Routes.subsectors_path {format: 'json'}
    @post(
      url: url
      body:
        id: subsector.id
        name: subsector.name
        description: subsector.description
    )
    .then(@status)
    .then (res) =>
      SubsectorsActionCreators.create_response res.body, res.ok
    .catch (error) ->
      alert error

  update: (subsector) ->
    url = Routes.subsector_path subsector.id, {format: 'json'}
    @put(
      url: url
      body: subsector
    )
    .then(@status)
    .then (res) =>
      SubsectorsActionCreators.update_response res.body, res.ok
    .catch (error) ->
      alert error

  destroy: (subsector) ->
    url = Routes.subsector_path subsector.id, {format: 'json'}
    @delete(
      url: url
      body:
        id: subsector.id
    )
    .then(@status)
    .then (res) ->
      SubsectorsActionCreators.destroy_response res.body, res.ok
    .catch (error) ->
      alert error

  move: (subsector, to) ->
    url = Routes.move_subsector_path subsector.id, {format: 'json'}
    @put(
      url: url
      body: {sector_id: subsector.sector_id, to: to}
    )
    .then(@status)
    .then (res) ->
      SubsectorsActionCreators.move_response res.body, res.ok
    .catch (error) ->
      alert error

module.exports = SubsectorsAPI