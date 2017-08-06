class ReceiptsController < ApplicationController  
  before_action :authenticate_user!
  layout 'application'

  def index
    @receipts = current_user.receipts.all
  end

  def create
    @receipt = current_user.receipts.build receipt_params

    if @receipt.image.present?
      tesseract_image = RTesseract.new(@receipt.image.path)

      @receipt.pdf = File.open(tesseract_image.to_pdf)
      @receipt.text = tesseract_image.to_s.downcase
    end

    @receipt.text.split("\n").each_with_index do |line, index|
      next if line.strip.blank?

      store = nil

      # Check first 6 lines for store name
      if index < 6 && store.blank? && line.downcase.match(/([\w\']{2,})/)
        line.downcase.match(/([\w\']{2,})/).captures.each do |string|
          next if store.present?
          store = Store.find_by_name(string)
        end
      end

      line.match(/(.+)\s+([0-9]{13})\s+(\d+\.\d+)\s+(\w)/) do |match|
        name = match[1]
        id = match[2]
        price = match[3]
        tax = match[4]
        
        @receipt.transactions.build name: name, raw: line, price: price, user: current_user
      end
    end

    if @receipt.save
      redirect_to receipt_path(@receipt)
    else
      @receipts = current_user.receipts
      flash[:error] =  @receipt.errors.full_messages.first
      render :index
    end
  end

  def show
    @receipt = current_user.receipts.includes(:transactions).find(params[:id])
  end

  def destroy
    @receipt = current_user.receipts.find(params[:id])
    @receipt.destroy
    flash[:notice] = "Receipt deleted."
    redirect_to receipts_path
  end

  private

  def receipt_params
    params.require(:receipt).permit(:image, :image_cache)
  end
end
