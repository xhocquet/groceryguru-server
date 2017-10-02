var airbrake = null;

$(document).ready(function(){
  $('.notification .delete').click(function(e) {
    $(e.target).parents('.notification').removeClass('show');
  });

  setTimeout(function() {
    $('.notification.show').removeClass('show', 1000);
  }, 2500);

  airbrake = new airbrakeJs.Client({
    projectId: 158633,
    projectKey: '1e9af05019fae17943d7670466938217'
  });
  airbrake.addFilter(function (notice) {
    notice.context.environment = 'production';
    return notice;
  });
});