{div, span} = React.DOM
SectorHeader = React.createFactory require ('./sector_header')
SectorProgressBar = React.createFactory require ('./sector_progress_bar')
SectorForm = React.createFactory require ('./sector_form')
EmojiSelector = require './emoji_selector'
SectorsActionCreators = require '../actions/sectors_actions'

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

  _onIconSelect: (e)->
    react_modal EmojiSelector, { emoji: @props.sector.icon }
      .then (emoji) =>
        SectorsActionCreators.update @props.sector,
          icon: emoji

  render: ->
    div
      className: "sector row " + if @props.current then 'current-sector' else ''
      style: {backgroundColor: @props.sector.color}
      onClick: @_onSectorSelect

      if @props.sector.editing
        div
          className: 'sector-icon-editing'
          onClick: @_onIconSelect
          div null,
            @props.sector.icon
      else
        div className: 'sector-icon',
          div {},
            @props.sector.icon
      div
        className: 'sector-full ' + if @props.full then '' else 'hidden-xs'
        if @props.sector.editing
          SectorForm key: @props.sector.id, sector: @props.sector
        else
          SectorHeader key: "header-#{@props.sector.id}", sector: @props.sector

        SectorProgressBar
          data: @props.sector.weeks[WeeksStore.getCurrentWeek().id]
          show_edit_lapa: @props.lapa_editing or @props.sector.editing
          edit_lapa_callback: @_onLapaChange


module.exports = Sector;