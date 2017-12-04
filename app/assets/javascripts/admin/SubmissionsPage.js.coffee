class @AdminSubmissionsPage
  constructor: (@options = {}) ->
    $(document).on 'turbolinks:load', =>
      $('.validate-link').click (e) ->
        e.preventDefault()
        $(e.currentTarget).parents('form').submit()
