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
  $('div.data').click(function(e) {
    // Prevent duplicating inputs
    if ($(e.currentTarget).find('input').length > 0) {
      return;
    }

    var fieldName = $(e.currentTarget).data('field-name');
    var newInput = document.createElement("input");

    curHeight = $(e.currentTarget).height();
    curWidth = $(e.currentTarget).width();

    newInput.type = "text";
    newInput.classList.add('input');
    newInput.style.maxWidth = curWidth+'px';
    newInput.style.maxHeight = curHeight+'px';
    newInput.value = $(e.currentTarget).text();
    newInput.name = 'transaction['+fieldName+']';

    $(e.currentTarget).empty();
    $(newInput).appendTo(e.currentTarget);
    $(newInput).select();

    $(newInput).keypress(function(e) {
      if (e.which === 13) {
        e.preventDefault();
        $(e.currentTarget).parents('.table-row').find('.save-button').click();
      }
    });

    $(e.currentTarget).parents('.table-row').find('.save-button').removeAttr('disabled');
  });

  // Save transaction row
  $('a.save-button').click(function(e) {
    if ($(e.currentTarget).attr('disabled')) {
      return;
    }

    $(e.currentTarget).parents('form').submit();
  });

  $('.add-new-transaction-button').click(function(e) {
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
  });
});