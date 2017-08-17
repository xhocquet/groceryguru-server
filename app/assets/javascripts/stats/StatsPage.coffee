class @StatsPage
  constructor: (@options = {}) ->
    $(document).on 'turbolinks:load', => @setupEventListeners()


  setupEventListeners: ->
    $('.toggle-card-button').click (e) ->
      if $(e.currentTarget).find('i.material-icons').text() == 'keyboard_arrow_right'
        $(e.currentTarget).find('i.material-icons').text('keyboard_arrow_down')
      else
        $(e.currentTarget).find('i.material-icons').text('keyboard_arrow_right')

      $(e.currentTarget).siblings('.transaction-list').toggleClass('is-hidden')