class @RootPage
  constructor: (@options = {}) ->
    $(document).on 'turbolinks:load', => @setupEventListeners()

  setupEventListeners: () ->
    $('.receipt-upload-input').click (e) => @handleFileButtonClick(e)
    $('.receipt-upload-input').change (e) => @handleFileChanged(e)
    $('.close-modal-button').click (e) => @closeModal(e)
    $('.save-crop-button').click (e) => @handleReceiptUpload(e)

  handleFileButtonClick: (e) ->
    $('.modal-loader').removeClass 'is-hidden'
    $('.crop-modal').addClass 'is-active'

  handleFileChanged: (e) ->
    reader = new FileReader()
    reader.onload = @onLoadImage
    reader.readAsDataURL(e.currentTarget.files[0])

  onLoadImage: (e) =>
    $('.receipt-preview').attr('src', e.target.result)
    $('.modal-loader').addClass 'is-hidden'
    @cropper = new Cropper($('.receipt-preview')[0], {
      viewMode: 2,
      crop: (e) ->
        $('.image_crop_x').val(e.detail.x)
        $('.image_crop_y').val(e.detail.y)
        $('.image_crop_w').val(e.detail.width)
        $('.image_crop_h').val(e.detail.height)
    })

  closeModal: (e) =>
    $('.crop-modal').removeClass 'is-active'
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