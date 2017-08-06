$(document).ready(function(){
  $('.notification .delete').click(function(e) {
    $(e.target).parents('.notification').removeClass('show');
  });

  setTimeout(function() {
    $('.notification.show').removeClass('show');
  }, 2500);
});