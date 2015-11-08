{div, span} = React.DOM
Button = React.createFactory require('./button')
Sticky = React.createFactory require('react-sticky')
WeeksActionCreators = require '../actions/weeks_actions'

WeekHeader = React.createClass
  displayName: 'WeekHeader'

  _onEditLapa: ->
    WeeksActionCreators.edit_lapa @props.week

  render: ->
    Sticky className: 'z-index-top',
      div className: 'navbar-default', id: "week-header",
        Button
          tag: 'button', on_click: @_onEditLapa,
          active: @props.week.lapa_editing
          glyphicon: 'cog', title: 'edit lapa'

        div className: 'week-navbar pull-right',
          div className: 'btns-left',
            Button
              tag: 'a', href: @props.week.prev_path, id: "prev-week-link"
              glyphicon: 'arrow-left', title: 'go to previous week'

          div className: 'week-info',
            div className: 'week-dates',
              @props.week.begin_end_text
            div {},
              _.map @props.week.days, (day)->
                span
                  key: day['date']
                  className: "label label-#{day['status']}"
                  day['name']

          div className: 'btns-right',
            if @props.week.next_path
              Button
                tag: 'a', href: @props.week.next_path, id: "next-week-link"
                glyphicon: 'arrow-right', title: 'go to next week'


module.exports = WeekHeader;