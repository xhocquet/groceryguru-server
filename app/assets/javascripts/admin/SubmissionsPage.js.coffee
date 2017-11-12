class @AdminSubmissionsPage
  constructor: (@options = {}) ->
    $(document).on 'turbolinks:load', =>
      @setupEventListeners()

    $('.validate-link').click (e) ->
      e.preventDefault()
      $(e.currentTarget).parents('form').submit()
