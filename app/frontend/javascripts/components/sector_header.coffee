{div, span} = React.DOM
Button = React.createFactory require('./button')
EPutils = require '../ep_utils'

SectorsActionCreators = require '../actions/sectors_actions'
UIActionCreators = require '../actions/ui_actions'

SectorHeader = React.createClass
  displayName: 'SectorHeader'

  _onEdit: (e) ->
    e.preventDefault()
    SectorsActionCreators.edit @props.sector

  _onHideSectors: ->
    UIActionCreators.show_sectors()

  render: ->
    div className: "sector-header toolbar", title: @props.sector.description,
      div
        className: "sector-name"
        onClick: @_onHideSectors
        span {}, @props.sector.name

      div className: 'btns-right',
        Button
          on_click: @_onEdit
          color: 'default', size: 'sm'
          glyphicon: 'pencil', title: I18n.edit + ' ' + I18n.sector


module.exports = SectorHeader;