$(document).ready(function(){
  $('.notification .delete').click(function(e) {
    $(e.target).parents('.notification').removeClass('show');
  });
});