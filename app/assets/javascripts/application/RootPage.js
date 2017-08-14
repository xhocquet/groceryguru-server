class RootPage {
  constructor(props) {
    $(document).on('turbolinks:load', function() {
      $('.receipt-upload-input').change(function(e) {
        $(e.currentTarget).parents('form').submit();

        $(e.currentTarget).parents('div.file').addClass('is-hidden');
        $(e.currentTarget).parents('div.file').siblings('.sk-cube-grid').removeClass('is-hidden');
        $(e.currentTarget).parents('div.file').siblings('.loading-title').removeClass('is-hidden');
      })
    });
  }
}