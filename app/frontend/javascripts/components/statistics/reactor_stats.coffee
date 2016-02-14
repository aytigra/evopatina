{div, span, input} = React.DOM
PolarAreaChart = React.createFactory require("react-chartjs").PolarArea

ReactorStats = React.createClass
  displayName: 'ReactorStats'

  shouldComponentUpdate: (newProps, newState) ->
    newProps.stats_ver isnt @props.stats_ver or
    newProps.redraw isnt @props.redraw or
    newProps.fragments isnt @props.fragments

  render: ->
    data = _.map AppStore.get_day().sectors, (sector) ->
      value: Math.abs(AppStore.sector_status(sector)),
      color: AppStore.get_sector(sector).color || "rgba(220,220,220,0.5)",
      label: AppStore.get_sector(sector).name

    div className: '',
      div className: 'reactor-title text-center', I18n.stats.reactor_title
      div className: 'reactor-fragments text-center',
        I18n.stats.reactor_fragments
        input
          style:
            width: '30px'
          onChange: @props.on_fragments_change
          value: @props.fragments

      PolarAreaChart
        data: data
        options:
          tooltipTemplate: "<%= value %>%: <%=label%>"
          tooltipCaretSize: 0
          responsive: true
          animation: false
        redraw: true

module.exports = ReactorStats;