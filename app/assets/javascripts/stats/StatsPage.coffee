class @StatsPage
  constructor: (@options = {}) ->
    $(document).on 'turbolinks:load', => @setupEventListeners()

  setupEventListeners: ->
    $('.toggle-card-button').click (e) =>
      @toggleDropdown(e.currentTarget)
      $(e.currentTarget).siblings('.transaction-list').toggleClass('is-hidden')

    $('.toggle-transaction-group').click (e) =>
      @toggleDropdown(e.currentTarget)
      $(e.currentTarget).parents('.box').next('.transactions-list').toggleClass('is-hidden')

  toggleDropdown: (target) ->
    if $(target).find('i.material-icons').text() == 'keyboard_arrow_right'
      $(target).find('i.material-icons').text('keyboard_arrow_down')
    else
      $(target).find('i.material-icons').text('keyboard_arrow_right')