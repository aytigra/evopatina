{div, span} = React.DOM
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
    newProps.lapa_editing isnt @props.lapa_editing or
    newProps.full isnt @props.full

  _onSectorSelect: ->
    WeeksActionCreators.select_sector @props.sector if @props.sector.id != WeeksStore.getCurrentSector()

  _onLapaChange: (e)->
    WeeksActionCreators.update_lapa {"#{@props.sector.id}": e.target.value}

  render: ->
    div
      className: "sector row " + if @props.current then 'current-sector' else ''
      style: {backgroundColor: @props.sector.color}
      onClick: @_onSectorSelect

      div
        className: if @props.full then '' else 'hidden-xs'
        if @props.sector.editing
          SectorForm key: @props.sector.id, sector: @props.sector
        else
          SectorHeader key: "header-#{@props.sector.id}", sector: @props.sector

        SectorProgressBar
          data: @props.sector.weeks[WeeksStore.getCurrentWeek().id]
          show_edit_lapa: @props.lapa_editing or @props.sector.editing
          edit_lapa_callback: @_onLapaChange

      div
        className: if @props.full then 'hidden' else 'visible-xs-block'
        style: {padding: '3px'}
        span className: "glyphicon glyphicon-#{@props.sector.icon}", 'aria-hidden': "true"


module.exports = Sector;