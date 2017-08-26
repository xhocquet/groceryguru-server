class @ShowReceiptPage
  constructor: (@options = {}) ->
    @$newTransactionForm = $('.new-transaction-form')

    $(document).on 'turbolinks:load', =>
      @setupEventListeners()

  setupEventListeners: ->
    # Show receipt button
    $('.show-receipt-button').click (e) ->
      e.preventDefault()
      $('.receipt-modal').toggleClass('is-active')

    # Close modal
    $('.modal-background, .modal-close').click (e) ->
      $('.modal.is-active').removeClass('is-active')

    # Close modal with escape
    $(document).keyup (e) ->
      if e.which == 27
        $('.modal.is-active').removeClass('is-active')

    # Toggle dropdown
    $('.dropdown-trigger').click (e) ->
      $(e.currentTarget).parents('.dropdown').toggleClass('is-active')

    # Populate input on item click
    $('div.data').click @populateDataInput

    # Save transaction row
    $('a.save-button').click (e) ->
      return if $(e.currentTarget).attr('disabled')
      $(e.currentTarget).parents('form').submit()

    $('.select-transaction-cell').click @goToTransaction

    # Add row for new transaction
    $('.add-new-transaction-button').click @onClickNewTransaction

    # Remove new transaction row
    $('.delete-new-transaction').click (e) ->
      e.preventDefault()
      @$newTransactionForm.addClass('is-hidden')
      $('.add-new-transaction-button').attr('disabled', false)

    $('.add-store-button').click (e) =>
      e.preventDefault()
      @initiateStoreSearch()

    $('.store-title-span').click (e) =>
      @initiateStoreSearch()

    $('.add-date-button').click (e) =>
      e.preventDefault()
      @initiateDateInput()

    $('.date-title-span').click (e) =>
      @initiateDateInput()

  initiateStoreSearch: ->
    $storeButtonOrLabel = $('.add-store-button, .store-title-span')
    $storeInput = $('input.store-input')
    $hiddenIDInput = $storeInput.siblings('input#receipt_store_id')

    $storeButtonOrLabel.addClass('is-hidden')
    $storeInput.removeClass('is-hidden')

    $storeInput.keyup (e) ->
      $storeInput.parents('form').submit() if e.which == 13

    autoComplete = new Awesomplete($storeInput[0], {autoFirst: true})

    $storeInput.on 'awesomplete-selectcomplete', (e) ->
      $hiddenIDInput.attr('value', e.originalEvent.text.value)
      this.value = e.originalEvent.text.label

    # Trigger search on debounced text input
    $storeInput.keyup(_.debounce((e) =>
      return if @validateAutocompleteKeypress(e)
      @populateAutocomplete(e.currentTarget.value, @options.storeSearchPath, autoComplete, @storeSearchJSONMap)
    , 300))

    $storeInput.select()

  initiateDateInput: ->
    $dateButtonOrSpan = $('.add-date-button, .date-title-span')
    $dateInput = $('input.date-input')

    $dateButtonOrSpan.addClass('is-hidden')
    $dateInput.removeClass('is-hidden')

    $dateInput.keyup (e) ->
      $dateInput.parents('form').submit() if e.which == 13

    $dateInput.select()

  populateAutocomplete: (value, path, autoComplete, JSONparseMethod) ->
    ajax = new XMLHttpRequest()
    ajax.open("GET", path+'/'+value, true)
    ajax.onload = () ->
      currentList = JSON.parse(ajax.responseText).map(JSONparseMethod)
      autoComplete.list = currentList
    ajax.send()

  storeSearchJSONMap: (i) ->
    { label: i.name, value: i.id}

  itemSearchJSONMap: (i) ->
    { label: i.name + (if i.mode != undefined then (' - ' + i.mode.name) else ''), value: i.id }

  clickNearestSaveButton: (e) ->
    e.preventDefault()
    $(e.currentTarget).parents('.table-row').find('.save-button').click()

  onClickNewTransaction: (e) =>
    e.preventDefault()
    $(e.currentTarget).attr('disabled', true)

    @$newTransactionForm.find('input').keypress (e) =>
      @clickNearestSaveButton(e) if e.which == 13

    $lastRow = $('.select-transaction-cell').last().parents('.table-row')

    if $lastRow.length > 0
      @$newTransactionForm.find('.table-cell').each (index, item) ->
        item.style.maxWidth = $lastRow.find('.table-cell')[index].offsetWidth+"px"

    @$newTransactionForm.removeClass('is-hidden')
    @setupItemAutocompleteCell(@$newTransactionForm.find('.table-cell.data').first())
    @$newTransactionForm.find('.input').first().select()

  selectNextInput: ($currentTarget) =>
    $currentCell = $currentTarget.parents('.table-cell')

    $cellsInCurrentRow = $currentCell.parents('form').find('.table-cell.data')

    indexOfCurrentCell = $cellsInCurrentRow.index($currentCell)
    $currentRow = $currentCell.parents('form.table-row')
    $nextCell = null

    if indexOfCurrentCell == $cellsInCurrentRow.length - 1
      $currentRow = $currentRow.next('form.table-row')
      $nextCell = $($currentRow.find('.table-cell.data')[0])
    else
      indexOfNextCell = indexOfCurrentCell += 1
      $nextCell = $($cellsInCurrentRow[indexOfNextCell])

    @insertInputIntoCell($nextCell)

  populateDataInput: (e) =>
    @insertInputIntoCell($(e.currentTarget))

  insertInputIntoCell: ($tableCell) =>
    # Prevent duplicating inputs
    if $tableCell.find('input').length > 0
      return

    currentFieldName = $tableCell.data('field-name')
    currentValue = $tableCell.text()

    curHeight = $tableCell.outerHeight()
    curWidth = $tableCell.width()

    newInput = document.createElement("input")
    newInput.type = "text"
    newInput.classList.add('input')
    newInput.style.verticalAlign = 'baseline';

    $tableCell[0].style.maxWidth = curWidth+'px'
    $tableCell[0].style.maxHeight = curHeight+'px'
    $tableCell[0].style.padding = 0

    if currentValue != '-'
      newInput.value = currentValue
    newInput.name = 'transaction['+currentFieldName+']'

    $tableCell.html(newInput)

    # Special autocomplete stuff for name
    if currentFieldName == 'name'
      @setupItemAutocompleteCell($tableCell)

    $(newInput).keypress (e) =>
      @clickNearestSaveButton(e) if (e.which == 13)

    # Cycle inputs tab
    $(newInput).keydown (e) =>
      if e.which == 9
        e.preventDefault()
        @selectNextInput($(e.currentTarget))

    $tableCell.parents('.table-row').find('.save-button').removeAttr('disabled')
    $(newInput).select()

  validateAutocompleteKeypress: (e) ->
    true if e.currentTarget.value.size < 3
    true if e.key.match(/Arrow/)
    true if e.key.match(/Enter/)
    false

  # Setup for autocomplete input
  setupItemAutocompleteCell: ($tableCell) ->
    newInput = $tableCell.find('input')[0]
    hiddenInput = document.createElement("input")
    autoComplete = new Awesomplete(newInput, {autoFirst: true})

    hiddenInput.type = "hidden"
    hiddenInput.name = 'transaction[item_id]'
    $(hiddenInput).appendTo($tableCell)

    $(newInput).on 'awesomplete-selectcomplete', (e) ->
      $(this).parents('.table-cell').find("input[name='transaction[item_id]']").attr('value', e.originalEvent.text.value)
      this.value = e.originalEvent.text.label

    # Trigger search on debounced text input
    $(newInput).keyup(_.debounce (e) =>
      return if @validateAutocompleteKeypress(e)
      @populateAutocomplete(e.currentTarget.value, @options.itemSearchPath, autoComplete, @itemSearchJSONMap)
    , 300)

    @populateAutocomplete(newInput.value, @options.itemSearchPath, autoComplete, @itemSearchJSONMap)

  # Autoscroll to transaction line
  goToTransaction: (e) ->
    lineNumber = $(e.currentTarget).parents('.table-row').data('line-number')
    selectedSpan = $('body').find('pre').find('span').get(lineNumber - 1)
    $(selectedSpan).addClass('focused')
    $('html, body').animate
      scrollTop: $(selectedSpan).offset().top