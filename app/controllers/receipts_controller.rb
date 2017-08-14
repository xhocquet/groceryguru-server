class ReceiptsController < ApplicationController
  def index
    @receipts = current_user.receipts.all
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
    @receipt = current_user.receipts.includes(:transactions).find(params[:id])
  end

  def destroy
    @receipt = current_user.receipts.find(params[:id])
    @receipt.destroy
    flash.now[:notice] = "Invisible"
    flash[:notice] = "Receipt deleted."
    redirect_to receipts_path
  end

  private

  def receipt_params
    params.require(:receipt).permit(:image, :image_cache)
  end
end
