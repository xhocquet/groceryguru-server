class TransactionsController < ApplicationController
  before_action :load_transaction, except: :create

  def create
    @receipt = Receipt.find(params[:receipt_id])
    @transaction = @receipt.transactions.build transaction_params

    if @transaction.save
      flash[:notice] = "Transaction added"
    else
      flash[:error] = @transaction.errors.full_messages.first
    end
    redirect_to receipt_path(@receipt)
  end

  def update
    if @transaction.update transaction_params
      flash[:notice] = "Transaction updated"
    else
      flash[:error] =  @transaction.errors.full_messages.first
    end
    redirect_to receipt_path(@receipt)
  end

  def destroy
    @transaction.destroy
    flash[:notice] = "Transaction deleted"
    redirect_to receipt_path(@receipt)
  end

  private

  def load_transaction
    @transaction = current_user.transactions.find(params[:id])
    @receipt = @transaction.receipt
  end

  def transaction_params
    params.require(:transaction).permit(:name, :weight, :price, :count, :weight, :raw, :item_id).merge({user: current_user})
  end
end