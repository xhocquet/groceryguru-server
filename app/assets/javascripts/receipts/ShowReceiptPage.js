class ShowReceiptPage {
  constructor(options = {}) {
    self = this;
    this.options = options;
    this.$newTransactionForm = $('.new-transaction-form');

    $(document).on('turbolinks:load', function() {
      self.setupEventListeners();
    });
  }

  setupEventListeners() {
    // Show receipt button
    $('.show-receipt-button').click(function(e) {
      e.preventDefault();
      $('.receipt-modal').toggleClass('is-active');
    });

    // Close modal
    $('.modal-background, .modal-close').click(function(e) {
      $('.modal.is-active').removeClass('is-active');
    });

    // Close modal with escape
    $(document).keyup(function(e) {
      if (e.which == 27) {
        $('.modal.is-active').removeClass('is-active');
      }
    });

    // Toggle dropdown
    $('.dropdown-trigger').click(function(e) {
      $(e.currentTarget).parents('.dropdown').toggleClass('is-active');
    }); 

    // Populate input on item click
    $('div.data').click(self.populateDataInput);

    // Save transaction row
    $('a.save-button').click(function(e) {
      if ($(e.currentTarget).attr('disabled')) {
        return;
      }

      $(e.currentTarget).parents('form').submit();
    });

    $('.select-transaction-cell').click(self.goToTransaction);

    // Add row for new transaction
    $('.add-new-transaction-button').click(self.onClickNewTransaction);

    // Remove new transaction row
    $('.delete-new-transaction').click(function(e) {
      e.preventDefault();
      self.$newTransactionForm.addClass('is-hidden');
      $('.add-new-transaction-button').attr('disabled', false);
    });
  }

  onClickNewTransaction(e) {
    e.preventDefault();
    $(e.currentTarget).attr('disabled', true);

    self.$newTransactionForm.find('input').keypress(function(e) {
      if (e.which === 13) {
        e.preventDefault();
        $(e.currentTarget).parents('.table-row').find('.save-button').click();
      }
    });

    self.$newTransactionForm.removeClass('is-hidden');
    self.setupItemAutocompleteCell(self.$newTransactionForm.find('.table-cell.data').first());
    self.$newTransactionForm.find('.input').first().select();
  }

  selectNextInput(currentTarget) {
    var $currentTarget = $(currentTarget);
    var $currentCell = $currentTarget.parents('.table-cell');

    var $cellsInCurrentRow = $currentCell.parents('form').find('.table-cell.data');

    var indexOfCurrentCell = $cellsInCurrentRow.index($currentCell);
    var $currentRow = $currentCell.parents('form.table-row');
    var $nextCell = null;

    if (indexOfCurrentCell === $cellsInCurrentRow.length - 1) {
      
      $currentRow = $currentRow.next('form.table-row')
      $nextCell = $($currentRow.find('.table-cell.data')[0])
    } else {
      var indexOfNextCell = indexOfCurrentCell += 1;
      $nextCell = $($cellsInCurrentRow[indexOfNextCell])
    }

    self.insertInputIntoCell($nextCell);
  }

  populateDataInput(e) {
    self.insertInputIntoCell($(e.currentTarget));
  }

  insertInputIntoCell($tableCell) {
    // Prevent duplicating inputs
    if ($tableCell.find('input').length > 0) {
      return;
    }

    var fieldName = $tableCell.data('field-name');
    var newInput = document.createElement("input");
    var currentValue = $tableCell.text();

    var curHeight = $tableCell.height();
    var curWidth = $tableCell.width();

    newInput.type = "text";
    newInput.classList.add('input');
    newInput.style.maxWidth = curWidth+'px';
    newInput.style.maxHeight = curHeight+'px';
    newInput.value = currentValue;
    newInput.name = 'transaction['+fieldName+']';

    $tableCell.empty();
    $(newInput).appendTo($tableCell);

    // Special autocomplete stuff for name
    if (fieldName === 'name') {
      self.setupItemAutocompleteCell($tableCell);
    }

    $(newInput).select();

    $(newInput).keypress(function(e) {
      if (e.which === 13) {
        e.preventDefault();
        $tableCell.parents('.table-row').find('.save-button').click();
      }
    });

    // Cycle inputs tab
    $(newInput).keydown(function(e) {
      if (e.which === 9) {
        e.preventDefault();
        self.selectNextInput(e.currentTarget);
      }
    });

    $tableCell.parents('.table-row').find('.save-button').removeAttr('disabled');
  }

  setupItemAutocompleteCell($tableCell) {
    var newInput = $tableCell.find('input')[0];
    var hiddenInput = document.createElement("input");
    hiddenInput.type = "hidden";
    hiddenInput.name = 'transaction[item_id]';
    $(hiddenInput).appendTo($tableCell);

    var autoComplete = new Awesomplete(newInput, {autoFirst: true});
    $(newInput).on('awesomplete-selectcomplete', updateItemIDInput);

    function updateItemIDInput(event) {
      $(this).parents('.table-cell').find("input[name='transaction[item_id]']").attr('value', event.originalEvent.text.value);
      this.value = event.originalEvent.text.label;
    }

    function populateAutocomplete(value) {
      var ajax = new XMLHttpRequest();
      ajax.open("GET", self.options.itemSearchPath+'/'+value, true);
      ajax.onload = function() {
        let currentList = JSON.parse(ajax.responseText).map(function(i) { return { label: i.name, value: i.id}; });
        autoComplete.list = currentList;
      };
      ajax.send();
    }

    populateAutocomplete(newInput.value);

    // Trigger search on debounced text input
    $(newInput).keyup(_.debounce(function(e) {
      if (e.currentTarget.value.size < 3) { return; }
      if (e.key.match(/Arrow/)) { return; }
      if (e.key.match(/Enter/)) { return; }
      populateAutocomplete(e.currentTarget.value);
    }, 300));
  }

  goToTransaction(e) {
    var lineNumber = $(e.currentTarget).parents('.table-row').data('line-number')
    var selectedSpan = $('body').find('pre').find('span').get(lineNumber - 1)
    $(selectedSpan).addClass('focused')
    $('html, body').animate({
      scrollTop: $(selectedSpan).offset().top
    });
  }
}