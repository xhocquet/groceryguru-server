$(document).ready(function(){
  $('.show-receipt-button, .modal-close').click(function(e) {
    e.preventDefault();
    $('.modal').toggleClass('is-active');
  });

  $('.modal-background').click(function(e) {
    $('.modal.is-active').removeClass('is-active');
  });

  $(document).keyup(function(e) {
    if (e.which == 27) {
      $('.modal.is-active').removeClass('is-active');
    }
  });
});