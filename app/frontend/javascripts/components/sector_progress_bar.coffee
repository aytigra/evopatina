{div, span, input} = React.DOM

EPutils = require '../ep_utils'

SectorProgressBar = React.createClass
  displayName: 'SectorProgressBar'

  render: ->
    ratio = @props.progress / 1
    status = EPutils.sector_status_icon(ratio)

    div className: "toolbar sector-progress",
      div className: 'progress',
        div className: 'progress-bar progress-bar-success', role: 'progressbar', style: {width: ratio * 100 + "%"},
          div className: 'text-left text-muted',

      div className: "btns-right",
        span className: "glyphicon glyphicon-#{status}",


module.exports = SectorProgressBar;


