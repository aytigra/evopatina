{div, span} = React.DOM
SectorHeader = React.createFactory require ('./sector_header')
SectorProgressBar = React.createFactory require ('./sector_progress_bar')
SectorForm = React.createFactory require ('./sector_form')
EmojiSelector = require './selectors/emoji_selector'

SectorsActionCreators = require '../actions/sectors_actions'
UIActionCreators = require '../actions/ui_actions'

SectorGraph = React.createFactory require('./sector_graph')
moment = require("moment")

Sector = React.createClass
  displayName: 'Sector'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.sector isnt @props.sector or
    newProps.current isnt @props.current or
    newProps.full isnt @props.full

  _onSectorSelect: ->
    UIActionCreators.select_sector @props.sector if @props.sector.id != AppStore.getCurrentSector()

  _onIconSelect: (e)->
    react_modal EmojiSelector, { emoji: @props.sector.icon }
      .then (emoji) =>
        SectorsActionCreators.update @props.sector,
          icon: emoji

  _onEdit: (e) ->
    e.preventDefault()
    SectorsActionCreators.edit @props.sector

  render: ->
    labels =  _.map AppStore.get_day().days, (day) ->
      moment(day, "YYYYMMDD").format('DD-MM')

    div
      className: "sector row " + if @props.current then 'current-sector' else ''
      style: {backgroundColor: @props.sector.color}
      onClick: @_onSectorSelect

      if @props.sector.editing
        div
          className: 'sector-icon-editing ' + if @props.full then '' else 'hidden-xs'
          title:  I18n.select_emoji
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
          SectorHeader
            key: "header-#{@props.sector.id}"
            sector: @props.sector
            onEdit: @_onEdit

        SectorGraph
          key: @props.sector.id
          color: @props.sector.color
          progress: AppStore.get_progress(@props.sector.id)
          data: AppStore.get_sector_progress_data(@props.sector.id)
          labels: labels
          redraw: @props.full


module.exports = Sector;