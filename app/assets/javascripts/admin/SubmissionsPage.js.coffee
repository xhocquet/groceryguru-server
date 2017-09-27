class @AdminSubmissionsPage
  constructor: (@options = {}) ->
    $(document).on 'turbolinks:load', =>
      @setupEventListeners()

  setupEventListeners: () =>
    $('td.value-cell').click (e) =>
      @insertInputIntoCell($(e.currentTarget))

    $('.validate-link').click (e) ->
      e.preventDefault()
      $(e.currentTarget).parents('tr').find('form').submit()

  insertInputIntoCell: ($tableCell) =>
    # Prevent duplicating inputs
    if $tableCell.find('.validated-name-input').length > 0
      return

    curHeight = $tableCell.outerHeight()
    curWidth = $tableCell.width()

    newInput = document.createElement("input")
    newInput.type = "text"
    newInput.classList.add('input')
    newInput.classList.add('validated-name-input')
    newInput.style.verticalAlign = 'baseline'

    $tableCell[0].style.maxWidth = curWidth+'px'
    $tableCell[0].style.width = curWidth+'px'
    $tableCell[0].style.maxHeight = curHeight+'px'
    $tableCell[0].style.padding = 0

    newInput.value = $tableCell.text()
    newInput.name = "submission[name]"

    $tableCell.find('form').find('.invalid-name-text').replaceWith(newInput)

    $(newInput).keypress (e) =>
      @clickNearestSaveButton(e) if (e.which == 13)

    # Cycle inputs on tab keypress
    $(newInput).keydown (e) =>
      if e.which == 9
        e.preventDefault()
        if e.shiftKey
          @selectPreviousInput($(e.currentTarget))
        else
          @selectNextInput($(e.currentTarget))

    $tableCell.parents('tr').find('.validate-link').removeClass('is-hidden')
    $tableCell.parents('tr').find('.validate-info-icon').addClass('is-hidden')
    $(newInput).select()
