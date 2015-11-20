SectorsActionCreators = require '../actions/sectors_actions'

SectorsAPI = Marty.createStateSource
  id: 'SectorsAPI'
  type: 'http'

  status: (res) ->
    if res.status not in [200,201,422]
      throw new Error("#{res.status}: #{res.statusText}")
    res

  create: (sector) ->
    url = Routes.sectors_path {format: 'json'}
    @post(
      url: url
      body: sector
    )
    .then(@status)
    .then (res) =>
      SectorsActionCreators.create_response res.body, res.ok
    .catch (error) ->
      alert error

  update: (sector) ->
    url = Routes.sector_path sector.id, {format: 'json'}
    @put(
      url: url
      body:
        id: sector.id
        name: sector.name
        description: sector.description
        icon: sector.icon
        color: sector.color
    )
    .then(@status)
    .then (res) =>
      SectorsActionCreators.update_response res.body, res.ok
    .catch (error) ->
      alert error

  destroy: (sector) ->
    url = Routes.sector_path sector.id, {format: 'json'}
    @delete(
      url: url
      body:
        id: sector.id
    )
    .then(@status)
    .then (res) ->
      SectorsActionCreators.destroy_response res.body, res.ok
    .catch (error) ->
      alert error

  move: (sector, to) ->
    url = Routes.move_sector_path sector.id, {format: 'json'}
    @put(
      url: url
      body: {to: to}
    )
    .then(@status)
    .then (res) ->
      SectorsActionCreators.move_response res.body, res.ok
    .catch (error) ->
      alert error

module.exports = SectorsAPI