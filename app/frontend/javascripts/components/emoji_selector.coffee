Modal = React.createFactory require('./modal')

Promise = $.Deferred
{div, button, h4, ul, li, a, span} = React.DOM

EmojiSelector = React.createClass
  displayName: 'EmojiSelector'

  componentDidMount: ->
    @promise = new Promise()

  getDefaultProps: ->
    tabs: [
      '😁 😂 😃 😄 😅 😆 😉 😊 😋 😌 😍 😏 😒 😓 😔 😖 😘 😚 😜 😝 😞 😠 😡 😢 😣 😤 😥 😨 😩 😪 😫 😭 😰 😱 😲 😳 😵 😷',
      '😸 😹 😺 😻 😼 😽 😾 😿 🙀 🙅 🙆 🙇 🙈 🙉 🙊 🙋 🙌 🙍 🙎 🙏'
    ]
    default_tab: '😁'


  _abort: ->
    @promise.reject()

  _choose: (e) ->
    if e.target.className == 'selector-emoji'
      @promise.resolve(e.target.innerHTML)

  _onKeyDown: (e) ->
    if e.keyCode is 27
      @_abort()

  render: ->
    Modal null,
      div className: 'modal-header',
        h4 className: 'modal-title', "Select emoji"
        div
          className: 'modal-body modal-scrollable text-center'
          ul
            className: "nav nav-tabs", role: "tablist"
            @props.tabs.map (tab) =>
              emojis = tab.split(' ')
              tab_emoji = emojis[0]
              li
                className: if tab_emoji == @props.default_tab then 'active' else '',
                role: "presentation", key: tab_emoji
                a
                  href: "##{tab_emoji}", 'aria-controls': tab_emoji, role: "tab", 'data-toggle': "tab"
                  span className: "selector-emoji",
                    tab_emoji
          div
            className: "tab-content"
            @props.tabs.map (tab) =>
              emojis = tab.split(' ')
              tab_emoji = emojis[0]
              div
                className: "tab-pane" + if tab_emoji == @props.default_tab then ' active' else ''
                onClick: @_choose
                role: "tabpanel", id: tab_emoji, key: tab_emoji
                emojis.map (emoji) =>
                  span
                    className: "selector-emoji", key: emoji
                    emoji


      div className: 'modal-footer',
        div className: 'text-right',
          button
            role: 'abort'
            type: 'button'
            className: 'btn btn-default'
            onClick: @_abort
            autoFocus: true
            onKeyDown: @_onKeyDown
            'Cancel'
          ' '

module.exports = EmojiSelector