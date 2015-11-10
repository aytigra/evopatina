{div, span} = React.DOM
Button = React.createFactory require('./button')
EPutils = require '../ep_utils'
WeeksStore = require '../stores/weeks_store'
SectorsActionCreators = require '../actions/sectors_actions'

SectorHeader = React.createClass
  displayName: 'SectorHeader'

  _onEdit: (e) ->
    e.preventDefault()
    SectorsActionCreators.edit @props.sector

  render: ->
    sector = @props.sector
    status = EPutils.sector_status_icon(sector.weeks[WeeksStore.getCurrentWeek().id])

    div className: "sector-header toolbar",
      div className: "btns-left",
        span className: "glyphicon glyphicon-#{sector.icon}", 'aria-hidden': "true"

      div className: "sector-name",
        span {}, sector.name

      div className: 'btns-right',
        Button
          on_click: @_onEdit
          color: 'default', size: 'sm'
          glyphicon: 'pencil', title: 'edit sector'


module.exports = SectorHeader;