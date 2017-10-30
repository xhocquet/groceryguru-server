class Api::ReceiptsController < Api::BaseController
  respond_to :json
  acts_as_token_authentication_handler_for User, if: lambda { |controller| controller.request.format.json? }

  def index
    @receipts = current_user.receipts.includes(:store).order(created_at: :desc).page(params[:page])
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

  private

  def receipt_params
    params.require(:receipt).permit(:image)
  end
end
