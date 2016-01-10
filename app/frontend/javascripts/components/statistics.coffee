{div, span} = React.DOM
Button = React.createFactory require('./button')
EPutils = require '../ep_utils'
LineChart = React.createFactory require("react-chartjs").Line

Statistics = React.createClass
  displayName: 'Statistics'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.sector isnt @props.sector or
    newProps.className isnt @props.className

  render: ->
    div className: @props.className,
      div style: { paddingLeft: '20px' },
        I18n.progress_history.replace '%{sector}', ''

      _.map AppStore.get_day().days, (day) ->
        div
          className: 'toolbar',
          style: { paddingLeft: '20px' }
          key: day,
          div className: 'btns-left',
            Button
              tag: 'a'
              href: day
              size: 'xs'
              glyphicon: 'link'
          day

      LineChart
        data: AppStore.state.progres
        options: {}

module.exports = Statistics;