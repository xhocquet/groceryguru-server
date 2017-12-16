class @RootPage
  constructor: (@options = {}) ->
    @receiptPreview = $('.receipt-preview')
    @saveCropButton = $('.save-crop-button')
    $(document).on 'turbolinks:load', => @setupEventListeners()

  setupEventListeners: () ->
    @receiptPreview.on 'load', @handleImagePreviewChanged
    $('.receipt-upload-input').click (e) => @handleFileButtonClick(e)
    $('.receipt-upload-input').change (e) => @handleFileChanged(e)
    $('.close-modal-button').click (e) => @closeModal(e)
    @saveCropButton.click (e) => @handleReceiptUpload(e)

  handleFileButtonClick: (e) ->
    $('.modal-loader').removeClass 'is-hidden'
    $('.crop-modal').addClass 'is-active'

  handleFileChanged: (e) ->
    if e.currentTarget.files.length > 0
      @saveCropButton.attr('disabled', false)
    else
      @saveCropButton.attr('disabled', true)

    reader = new FileReader()
    reader.onload = @onLoadImage
    reader.readAsDataURL(e.currentTarget.files[0])

  handleImagePreviewChanged: (e) ->
    if e.target.naturalWidth > 0
      $(e.target).removeClass 'is-hidden'
    else
      $(e.target).addClass 'is-hidden'

  onLoadImage: (e) =>
    @receiptPreview.attr('src', e.target.result)
    $('.modal-loader').addClass 'is-hidden'
    @cropper = new Cropper(@receiptPreview[0], {
      viewMode: 2,
      crop: (e) ->
        $('.image_crop_x').val(e.detail.x)
        $('.image_crop_y').val(e.detail.y)
        $('.image_crop_w').val(e.detail.width)
        $('.image_crop_h').val(e.detail.height)
    })

  closeModal: (e) =>
    $('.crop-modal').removeClass 'is-active'
    @receiptPreview.attr('src', '')
    @receiptPreview.addClass 'is-hidden'
    @saveCropButton.attr('disabled', true)

    @cropper?.destroy()

  handleReceiptUpload: (e) =>
    @closeModal(e)

    $('.file-container').addClass 'is-hidden'
    $('.file-upload-progress').removeClass 'is-hidden'
    $('.loading-title').removeClass 'is-hidden'

    @uploadReceiptImage()

  # Upload image to server
  uploadReceiptImage: () =>
    $.ajax
      url: @options.receiptUploadPath,
      type: 'POST',
      data: new FormData($('.create-receipt-form')[0]),
      cache: false,
      contentType: false,
      processData: false,
      xhr: () =>
        myXhr = $.ajaxSettings.xhr()
        if myXhr.upload
          myXhr.upload.addEventListener 'progress', (e) =>
            if e.lengthComputable
              $('.file-upload-progress').attr
                value: e.loaded,
                max: e.total,
          , false
        return myXhr;
    .done (data) =>
      $('.file-upload-progress').addClass 'is-hidden'
      $('.file-container').siblings('.sk-cube-grid').removeClass 'is-hidden'
      $('.loading-title').text("We got your receipt. Our tiny robots are trying to pull as much info as possible!")
      @receiptId = data.receiptId
      @callProcessText()

  callProcessText: () =>
    return unless @receiptId?
    $.ajax
      url: @options.receiptProcessTextPath,
      type: 'POST',
      data: { receipt_id: @receiptId },
    .done (data) =>
      window.location.href = data.receiptUrl