Modal = require '../shared/modal'

Promise = $.Deferred
{div, button, h4} = React.DOM

SubsectorsSelector = React.createClass
  displayName: 'SubsectorsSelector'

  componentDidMount: ->
    @promise = new Promise()

  propTypes:
    entry: React.PropTypes.object.isRequired
    type: React.PropTypes.string.isRequired

  _abort: ->
    @promise.reject()

  _choose: (to) ->
    @promise.resolve(to)

  _onKeyDown: (e) ->
    if e.keyCode is 27
      @_abort()

  render: ->
    children = []
    withsubs = @props.type is 'activity'

    _.map AppStore.get_day().sectors, (id) =>
      sector = AppStore.get_sector(id)
      classname = 'selector-sector bg-success'
      if not withsubs
        if sector.id is @props.entry.sector_id
            return
        classname += ' selector-clickable'
        sector_onclick = @_choose.bind(@, {sector_id: id})

      children.push(
        div
          className: classname
          key: "sector-#{id}"
          onClick: sector_onclick
          sector.name
      )
      if withsubs
        _.map sector.subsectors, (subid) =>
          subsector = AppStore.get_subsector(subid)
          if subsector.id isnt @props.entry.subsector_id
            children.push(
              div
                className: 'selector-susector bg-info selector-clickable'
                key: "subsector-#{subid}"
                onClick: @_choose.bind(@, {sector_id: id, subsector_id: subid})
                subsector.name
            )

    destination_type = if withsubs then 'subsector' else 'sector'

    React.createElement Modal, null,
      div className: 'modal-header',
        h4 className: 'modal-title', "Select new #{destination_type} for '#{@props.entry.name}'"
        div className: 'modal-body modal-scrollable',
          children
      div className: 'modal-footer',
        div className: 'text-right',
          button
            type: 'button', role: 'abort'
            className: 'btn btn-default'
            onClick: @_abort
            autoFocus: true
            onKeyDown: @_onKeyDown
            'Cancel'

module.exports = SubsectorsSelector