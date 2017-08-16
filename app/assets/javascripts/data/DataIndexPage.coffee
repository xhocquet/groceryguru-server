class @DataIndexPage
  constructor: (@options = {}) ->
    $(document).on 'turbolinks:load', => @setupEventListeners()


  setupEventListeners: ->
    $('.toggle-card-button').click (e) ->
      $(e.currentTarget).siblings('.transaction-list').toggleClass('is-hidden')