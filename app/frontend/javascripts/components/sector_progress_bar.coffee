{div, span, input} = React.DOM

EPutils = require '../ep_utils'

SectorProgressBar = React.createClass
  displayName: 'SectorProgressBar'

  render: ->
    data = @props.data
    progress = @props.data.progress
    lapa = @props.data.lapa
    ratio = if progress > 0 && lapa > 0 then (progress/lapa) * 100 else 0
    status = EPutils.sector_status_icon(data)

    div className: "toolbar",
      div className: "btns-left",
        span className: "glyphicon glyphicon-#{status}",

      div className: 'sector-progress', style: {paddingLeft: '20px'},
        div className: 'progress',
          div className: 'progress-bar progress-bar-success', role: 'progressbar', style: {width: ratio + "%"},
            div className: 'text-left text-muted',
              EPutils.round(progress, 2) + '/' + lapa

      if @props.show_edit_lapa
        div className: "btns-right lapa-edit-form",
          input
            onChange: @props.edit_lapa_callback
            value: data.lapa
            autoFocus: @props.current && @props.lapa_editing
            title: I18n.lapa

module.exports = SectorProgressBar;


