class ReceiptsController < ApplicationController
  def index
    @receipts = current_user.receipts.includes(:store, :transactions).order(date: :desc, created_at: :desc).page(params[:page])
  end

  def create
    @receipt = current_user.receipts.build receipt_params

    if @receipt.save
      redirect_to receipt_path(@receipt)
    else
      @receipts = current_user.receipts
      flash[:error] =  @receipt.errors.full_messages.first
      redirect_to root_path
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
