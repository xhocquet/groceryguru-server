class @StatsPage
  constructor: (@options = {}) ->
    $(document).on 'turbolinks:load', =>
      @setupEventListeners()

      $('.stats-search-bar').focus()

  setupEventListeners: =>
    $('.toggle-card-button').click (e) =>
      @toggleDropdown(e.currentTarget)
      $(e.currentTarget).siblings('.transaction-list').toggleClass('is-hidden')
      $('.stats-search-bar').focus()

    $('.toggle-transaction-group').click (e) =>
      @toggleDropdown(e.currentTarget)
      $(e.currentTarget).parents('.box').next('.transactions-list').toggleClass('is-hidden')
      $('.stats-search-bar').focus()

    $('.stats-search-bar').keyup (e) =>
      searchString = e.currentTarget.value.toLowerCase().trim()

      if searchString.length > 0
        $('.transactions-list-button-container').addClass 'is-hidden'
        $('.transactions-list').removeClass 'is-hidden'

        for element in $('.item-card')
          if $(element).find('.item-name').text().trim().toLowerCase().indexOf(searchString) > -1
            $(element).removeClass 'is-hidden'
            $(element).find('.transaction-list').removeClass 'is-hidden'
          else
            $(element).addClass 'is-hidden'

      else
        $('.transactions-list-button-container').removeClass 'is-hidden'
        $('.item-card').removeClass 'is-hidden'
        $('.transactions-list').addClass 'is-hidden'
        $('.transaction-list').addClass 'is-hidden'

  toggleDropdown: (target) ->
    if $(target).find('i.material-icons').text() == 'keyboard_arrow_right'
      $(target).find('i.material-icons').text('keyboard_arrow_down')
    else
      $(target).find('i.material-icons').text('keyboard_arrow_right')