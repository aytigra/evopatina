{div, span} = React.DOM
Button = React.createFactory require('./shared/button')
Sticky = React.createFactory require('./shared/sticky')
UIActionCreators = require '../actions/ui_actions'
SectorsActionCreators = require '../actions/sectors_actions'
moment = require("moment")

WeekHeader = React.createClass
  displayName: 'WeekHeader'

  _onSectorCreate: ->
    SectorsActionCreators.create null

  _onShowSectors: ->
    UIActionCreators.show_sectors()

  _onShowStats: ->
    UIActionCreators.show_stats()

  render: ->
    if @props.UI.show_sectors
      sectors_width = ' col-xs-11'
      week_width = ' col-xs-1'
      sector_buttons_class = ''
      week_nav_class = 'hidden-xs'
    else
      sectors_width = ' col-xs-1'
      week_width = ' col-xs-11'
      sector_buttons_class = ' hidden-xs'
      week_nav_class = ''

    Sticky
      className: 'sticky-nav'
      topOffset: '-82'
      div className: 'navbar-default clearfix', id: "week-header",
        div
          className: "col-lg-4 col-md-3 col-sm-5 #{sectors_width}"
          style: {paddingLeft: '2px'},
          Button
            tag: 'button', on_click: @_onShowSectors
            add_class: 'visible-xs-inline-block'
            active: @props.UI.show_sectors
            glyphicon: 'chevron-right', title: I18n.header.show_sectors

          Button
            tag: 'button', on_click: @_onSectorCreate
            add_class: sector_buttons_class
            glyphicon: 'plus', title: I18n.header.add_sector
            span null, I18n.header.add_sector_short

        div
          className: "col-lg-4 col-md-6 col-sm-7 #{week_width}"
          style: {marginRight: '-13px', paddingLeft: '12px'}
          div className: "week-navbar #{week_nav_class}",
            div className: 'btns-left',
              Button
                tag: 'a', href: @props.day.prev_path, id: "prev-week-link"
                glyphicon: 'arrow-left', title: I18n.header.prev_day

            div className: 'week-info',
              div className: 'week-dates',
                @props.day.text

            div className: 'btns-right',
              if @props.day.next_path
                Button
                  tag: 'a', href: @props.day.next_path, id: "next-week-link"
                  glyphicon: 'arrow-right', title: I18n.header.next_day

          div className: 'stats-navbar pull-right hidden-lg hidden-md', style: {marginRight: '-10px'},
            Button
              tag: 'button', on_click: @_onShowStats
              active: @props.UI.show_stats
              glyphicon: 'stats', title: I18n.header.show_stats


module.exports = WeekHeader;