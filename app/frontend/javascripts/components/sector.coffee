{div} = React.DOM
SectorHeader = React.createFactory require ('./sector_header')
SectorProgressBar = React.createFactory require ('./sector_progress_bar')
SectorForm = React.createFactory require ('./sector_form')

WeeksActionCreators = require '../actions/weeks_actions'
WeeksStore = require '../stores/weeks_store'

Sector = React.createClass
  displayName: 'Sector'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.sector isnt @props.sector or
    newProps.current isnt @props.current or
    newProps.lapa_editing isnt @props.lapa_editing

  _onSectorSelect: ->
    WeeksActionCreators.select_sector @props.sector

  _onLapaChange: (e)->
    WeeksActionCreators.update_lapa {"#{@props.sector.id}": e.target.value}

  render: ->
    div
      className: "sector row " + if @props.current then 'bg-success' else ''
      onClick: @_onSectorSelect
      if @props.sector.editing
        SectorForm key: @props.sector.id, sector: @props.sector
      else
        SectorHeader key: "header-#{@props.sector.id}", sector: @props.sector

      if @props.current and not @props.sector.editing
        div className: "list-description",
          @props.sector.description

      SectorProgressBar
        data: @props.sector.weeks[WeeksStore.getCurrentWeek().id]
        show_edit_lapa: @props.lapa_editing or @props.sector.editing
        edit_lapa_callback: @_onLapaChange

module.exports = Sector;