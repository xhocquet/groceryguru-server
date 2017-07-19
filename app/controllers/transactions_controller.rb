class TransactionsController < ActionController::Base
  before_action :authenticate_user!
  layout 'application'
  default_form_builder AppFormBuilder

  def index
    @receipt = current_user.receipts.find(params[:receipt_id])
    @transactions = @receipt.transactions
  end

  def new
  end

  def create
  end

  def edit
    @transaction = current_user.transactions.find(params[:id])
    @receipt = @transaction.receipt
  end

  def update
    @transaction = current_user.transactions.find(params[:id])
    @receipt = @transaction.receipt

    if @transaction.update transaction_params
      flash[:notice] = "Transaction updated"
      redirect_to edit_transaction_path(@transaction)
    else
      flash[:error] =  @transaction.errors.full_messages.first
      render :edit
    end
  end

  def destroy
  end

  private

  def transaction_params
    params.require(:transaction).permit(:name, :weight_value, :weight_unit, :price, :count)
  end
end