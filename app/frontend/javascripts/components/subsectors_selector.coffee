Modal = require './modal'
WeeksStore = require '../stores/weeks_store'

Promise = $.Deferred
{div, button, h4} = React.DOM

SubsectorsSelector = React.createClass
  displayName: 'SubsectorsSelector'

  componentDidMount: ->
    @promise = new Promise()

  propTypes:
    entry: React.PropTypes.object.isRequired
    sectors: React.PropTypes.object.isRequired
    type: React.PropTypes.string.isRequired

  _abort: ->
    @promise.reject()

  _choose: (to) ->
    @promise.resolve(to)

  render: ->
    children = []
    withsubs = @props.type is 'activity'

    for id, sector of @props.sectors
      classname = 'selector-sector bg-success'
      if not withsubs
        if sector.id is @props.entry.sector_id
            continue
        classname += ' selector-clickable'
        onclick = @_choose.bind(@, {sector_id: id})

      children.push(
        div
          className: classname
          key: "sector-#{id}"
          onClick: onclick
          sector.name
      )
      if withsubs
        for subid, subsector of sector.subsectors
          if subsector.id is @props.entry.subsector_id
            continue

          children.push(
            div
              className: 'selector-susector bg-info selector-clickable'
              key: "subsector-#{subid}"
              onClick: @_choose.bind(@, {sector_id: id, subsector_id: subid})
              subsector.name
          )

    destination_type = if withsubs then 'subsector' else 'sector'

    React.createElement Modal, null,
      div
        className: 'modal-header'
        h4 className: 'modal-title', "Select new #{destination_type} for '#{@props.entry.name}'"
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