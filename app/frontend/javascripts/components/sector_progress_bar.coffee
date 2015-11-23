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

    div className: "toolbar sector-progress",
      if @props.show_edit_lapa
        div className: "btns-left lapa-edit-form",
          input
            onChange: @props.edit_lapa_callback
            value: data.lapa
            autoFocus: @props.current && @props.lapa_editing
            title: I18n.lapa

      div className: 'progress',
        div className: 'progress-bar progress-bar-success', role: 'progressbar', style: {width: ratio + "%"},
          div className: 'text-left text-muted',
            EPutils.round(progress, 2) + '/' + lapa

      div className: "btns-right",
        span className: "glyphicon glyphicon-#{status}",


module.exports = SectorProgressBar;


