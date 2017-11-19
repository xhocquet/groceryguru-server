class @AdminSubmissionsPage
  constructor: (@options = {}) ->
    $(document).on 'turbolinks:load', =>
      @setupEventListeners()

      $('.controls input').focus()

    $('.validate-link').click (e) ->
      e.preventDefault()
      $(e.currentTarget).parents('form').submit()
