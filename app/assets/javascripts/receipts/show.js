let autoComplete = null;

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

function autocompleteReplace(text) {
  this.input.value = text;
}

function populateDataInput(e) {
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

  $(e.currentTarget).empty();
  $(newInput).appendTo(e.currentTarget);

  // Special autocomplete stuff for name
  if (fieldName === 'name') {
    autoComplete = new Awesomplete(newInput, {replace: autocompleteReplace, autoFirst: true});

    function populateAutocomplete(value) {
      var ajax = new XMLHttpRequest();
      ajax.open("GET", itemSearchPath+'/'+value, true);
      ajax.onload = function() {
        autoComplete.list = JSON.parse(ajax.responseText).map(function(i) { return { label: i.name, value: i.id}; });
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

$(document).ready(function(){
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

  // Add row for new transaction
  $('.add-new-transaction-button').click(onClickNewTransaction);
});