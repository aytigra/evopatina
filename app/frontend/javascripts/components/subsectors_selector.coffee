Modal = require './modal'
WeeksStore = require '../stores/weeks_store'

Promise = $.Deferred
{div, button, h4} = React.DOM

SubsectorsSelector = React.createClass
  displayName: 'SubsectorsSelector'

  componentDidMount: ->
    @promise = new Promise()

  propTypes:
    activity: React.PropTypes.object.isRequired
    sectors: React.PropTypes.object.isRequired

  _abort: ->
    @promise.reject()

  _subsector: (to) ->
    @promise.resolve(to)

  render: ->
    children = []

    for id, sector of @props.sectors
      children.push(
        div
          className: 'selector-sector bg-success'
          key: "sector-#{id}"
          sector.name
      )
      for subid, subsector of sector.subsectors
        if subsector.id is @props.activity.subsector_id
          continue

        children.push(
          div
            className: 'selector-susector bg-info selector-clickable'
            key: "susector-#{subid}"
            onClick: @_subsector.bind(@, {sector_id: id, subsector_id: subid})
            subsector.name
        )

    React.createElement Modal, null,
      div
        className: 'modal-header'
        h4 className: 'modal-title', "Select new subsector for '#{@props.activity.name}'"
        div
          className: 'modal-body modal-scrollable'
          children
      div
        className: 'modal-footer'
        div
          className: 'text-right'
          button
            role: 'abort'
            type: 'button'
            className: 'btn btn-default'
            onClick: @_abort
            'Cancel'

module.exports = SubsectorsSelector