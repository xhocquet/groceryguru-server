$(document).ready(function(){
  Raven.config('https://550e360a2a7c4820affa2ea8b61ecbdd@sentry.io/260445').install();

  $('.notification .delete').click(function(e) {
    $(e.target).parents('.notification').removeClass('show');
  });

  setTimeout(function() {
    $('.notification.show').removeClass('show', 1000);
  }, 2500);
});