class @RootPage
  constructor: (@options = {}) ->
    $(document).on 'turbolinks:load', => @setupEventListeners()

  setupEventListeners: () ->
    $('.receipt-upload-input').change (e) => @handleFileUpload(e)
    $('.receipt-upload-input').click (e) => @handleFileUploadClick(e)
    $('.close-modal-button').click (e) => @handleCloseModal(e)
    $('.save-crop-button').click (e) => @handleSaveCrop(e)

    $('.footer').addClass 'is-hidden'

  handleFileUploadClick: (e) =>
    $('.modal-loader').removeClass 'is-hidden'
    $('.crop-modal').addClass 'is-active'

  handleFileUpload: (e) ->

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

  handleCloseModal: (e) =>
    $('.crop-modal').removeClass 'is-active'
    @cropper?.destroy()

  handleSaveCrop: (e) =>
    @handleCloseModal(e)

    $('.create-receipt-form').submit()

    $('.file-container').addClass('is-hidden')
    $('.file-container').siblings('.sk-cube-grid').removeClass('is-hidden')
    $('.file-container').siblings('.loading-title').removeClass('is-hidden')