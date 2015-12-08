{div, span} = React.DOM
Button = React.createFactory require('./button')
Sticky = React.createFactory require('./sticky')
WeeksActionCreators = require '../actions/weeks_actions'
SectorsActionCreators = require '../actions/sectors_actions'

WeekHeader = React.createClass
  displayName: 'WeekHeader'

  _onEditLapa: ->
    WeeksActionCreators.edit_lapa @props.week

  _onSectorCreate: ->
    SectorsActionCreators.create null

  _onShowSectors: ->
    WeeksActionCreators.show_sectors()

  _onShowStats: ->
    WeeksActionCreators.show_stats()

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
            glyphicon: 'chevron-right', title: I18n.show + ' ' + I18n.sector_abbr

          Button
            tag: 'button', on_click: @_onSectorCreate
            add_class: sector_buttons_class
            glyphicon: 'plus', title: I18n.add + ' ' + I18n.sector
            span null, I18n.add_short + ' ' + I18n.sector_abbr
          Button
            tag: 'button', on_click: @_onEditLapa,
            active: @props.UI.lapa_editing
            add_class: sector_buttons_class
            glyphicon: 'cog', title: I18n.edit + ' ' + I18n.lapa_whom
            span null, I18n.edit_short + ' ' + I18n.lapa_whom

        div
          className: "col-lg-4 col-md-6 col-sm-7 #{week_width}"
          style: {marginRight: '-13px', paddingLeft: '12px'}
          div className: "week-navbar #{week_nav_class}",
            div className: 'btns-left',
              Button
                tag: 'a', href: @props.week.prev_path, id: "prev-week-link"
                glyphicon: 'arrow-left', title: I18n.prev.f + ' ' + I18n.week

            div className: 'week-info',
              div className: 'week-dates',
                @props.week.begin_end_text
              div {},
                _.map @props.week.days, (day)->
                  span
                    key: day['date']
                    className: "label label-#{day['status']}"
                    span className: 'hidden-xs',
                      day['name']

            div className: 'btns-right',
              if @props.week.next_path
                Button
                  tag: 'a', href: @props.week.next_path, id: "next-week-link"
                  glyphicon: 'arrow-right', title: I18n.next.f + ' ' + I18n.week

          div className: 'stats-navbar pull-right hidden-lg hidden-md', style: {marginRight: '-10px'},
            Button
              tag: 'button', on_click: @_onShowStats
              active: @props.UI.show_stats
              glyphicon: 'stats', title: I18n.show + ' ' + I18n.stats_whom


module.exports = WeekHeader;