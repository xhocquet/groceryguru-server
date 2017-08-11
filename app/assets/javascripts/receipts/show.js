function onClickNewTransaction(e) {
  e.preventDefault();
  $(e.currentTarget).attr('disabled', true);

  $('.new-transaction-form').find('input').keypress(function(e) {
    if (e.which === 13) {
      e.preventDefault();
      $(e.currentTarget).parents('.table-row').find('.save-button').click();
    }
  });

  $('.new-transaction-form').removeClass('is-hidden');
  
  $('.new-transaction-form').find('.input')[0].select();
}

function populateDataInput(e) {
  let autoComplete = null;
  let currentList = null;

  // Prevent duplicating inputs
  if ($(e.currentTarget).find('input').length > 0) {
    return;
  }

  var fieldName = $(e.currentTarget).data('field-name');
  var newInput = document.createElement("input");
  var currentValue = $(e.currentTarget).text();

  curHeight = $(e.currentTarget).height();
  curWidth = $(e.currentTarget).width();

  newInput.type = "text";
  newInput.classList.add('input');
  newInput.style.maxWidth = curWidth+'px';
  newInput.style.maxHeight = curHeight+'px';
  newInput.value = currentValue;
  newInput.name = 'transaction['+fieldName+']';

  var hiddenInput = null;

  $(e.currentTarget).empty();
  $(newInput).appendTo(e.currentTarget);

  // Special autocomplete stuff for name
  if (fieldName === 'name') {
    hiddenInput = document.createElement("input");
    hiddenInput.type = "hidden";
    hiddenInput.name = 'transaction[item_id]';
    $(hiddenInput).appendTo(e.currentTarget);

    autoComplete = new Awesomplete(newInput, {autoFirst: true});
    $(newInput).on('awesomplete-selectcomplete', updateItemIDInput);

    function updateItemIDInput(event) {
      $(this).parents('.table-cell').find("input[name='transaction[item_id]']").attr('value', event.originalEvent.text.value);
      this.value = event.originalEvent.text.label;
    }

    function populateAutocomplete(value) {
      var ajax = new XMLHttpRequest();
      ajax.open("GET", itemSearchPath+'/'+value, true);
      ajax.onload = function() {
        currentList = JSON.parse(ajax.responseText).map(function(i) { return { label: i.name, value: i.id}; });
        autoComplete.list = currentList;
      };
      ajax.send();
    }

    populateAutocomplete(currentValue);

    $(newInput).keyup(_.debounce(function(e) {
      if (e.currentTarget.value.size < 3) { return; }
      if (e.key.match(/Arrow/)) { return; }
      if (e.key.match(/Enter/)) { return; }
      populateAutocomplete(e.currentTarget.value);
    }, 300));
  }

  $(newInput).select();

  $(newInput).keypress(function(e) {
    if (e.which === 13) {
      e.preventDefault();
      $(e.currentTarget).parents('.table-row').find('.save-button').click();
    }
  });

  $(e.currentTarget).parents('.table-row').find('.save-button').removeAttr('disabled');
}

function goToTransaction(e) {
  lineNumber = $(e.currentTarget).parents('.table-row').data('line-number')
  selectedSpan = $('body').find('pre').find('span').get(lineNumber - 1)
  $(selectedSpan).addClass('focused')
  $('html, body').animate({
    scrollTop: $(selectedSpan).offset().top
  });
}

$(document).on('turbolinks:load', function() {
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
  $('div.data').click(populateDataInput);

  // Save transaction row
  $('a.save-button').click(function(e) {
    if ($(e.currentTarget).attr('disabled')) {
      return;
    }

    $(e.currentTarget).parents('form').submit();
  });

  $('.select-transaction-cell').click(goToTransaction);

  // Add row for new transaction
  $('.add-new-transaction-button').click(onClickNewTransaction);
});