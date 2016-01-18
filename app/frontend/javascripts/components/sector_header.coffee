{div, span} = React.DOM
Button = React.createFactory require('./shared/button')

SectorHeader = React.createClass
  displayName: 'SectorHeader'

  render: ->
    div className: "sector-header toolbar", title: @props.sector.description,
      div
        className: "sector-name"
        span {}, @props.sector.name

      div className: 'btns-right',
        Button
          on_click: @props.onEdit
          color: 'default', size: 'sm'
          glyphicon: 'pencil', title: I18n.sectors.edit


module.exports = SectorHeader;