class ReceiptsController < ApplicationController
  def index
    @receipts = current_user.receipts.includes(:store, :transactions).order(date: :desc, created_at: :desc).page(params[:page])
  end

  # Used for home page upload
  def create
    @receipt = current_user.receipts.build receipt_params

    if @receipt.save
      render json: {
        receiptId: @receipt.id
      }, status: 200
    else
      render json: {
        error: @receipt.errors.full_messages.first,
      }, status: 400
    end
  end

  # Used for home page upload
  def process_text
    @receipt = current_user.receipts.find(params[:receipt_id])
    if @receipt.present?
      @receipt.process_text!
      render json: { receiptUrl: receipt_url(@receipt)}, status: 200
    else
      render json: {
        error: @receipt.errors.full_messages.first,
      }, status: 400
    end
  end

  def show
    @receipt = current_user.receipts.includes(transactions: :item).find(params[:id].to_i)
  end

  def update
    @receipt = current_user.receipts.find(params[:id])

    if @receipt.update receipt_params
      flash[:notice] = "Receipt updated"
    else
      flash[:error] = "Something went wrong, try again"
    end
    redirect_to receipt_path(@receipt)
  end

  def destroy
    @receipt = current_user.receipts.find(params[:id])
    @receipt.destroy
    flash[:notice] = "Receipt deleted"
    redirect_to receipts_path
  end

  private

  def receipt_params
    params.require(:receipt).permit(:image_crop_x, :image_crop_y, :image_crop_w, :image_crop_h, :image, :image_cache, :store_id).merge({date: Chronic.parse(params[:receipt][:date]) || @receipt.try(:date) || @receipt.try(:created_at)})
  end
end
