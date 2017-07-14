class ReceiptsController < ActionController::Base
  before_action :authenticate_user!

  def index
    @receipts = current_user.receipts.all
  end

  def create
    @receipt = current_user.receipts.build receipt_params

    if @receipt.image.present?
      tesseract_image = RTesseract.new(@receipt.image.path)

      @receipt.pdf = File.open(tesseract_image.to_pdf)
      @receipt.text = tesseract_image.to_s
    end

    if @receipt.save
      redirect_to receipt_path(@receipt)
    else
      flash.error "Error"
      render :edit
    end
  end

  def show
    @receipt = Receipt.find(params[:id])
  end

  private

  def receipt_params
    params.require(:receipt).permit(:image, :image_cache)
  end
end
