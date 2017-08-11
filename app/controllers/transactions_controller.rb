class TransactionsController < ApplicationController
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
    @transaction = current_user.transactions.find(params[:id])
    @receipt = @transaction.receipt
    
    if @transaction.update transaction_params
      flash[:notice] = "Transaction updated"
      redirect_to receipt_path(@receipt)
    else
      flash[:error] =  @transaction.errors.full_messages.first
      render :edit
    end
  end

  def destroy
    @transaction = current_user.transactions.find(params[:id])
    @receipt = @transaction.receipt
    @transaction.destroy
    flash[:notice] = "Transaction deleted"
    redirect_to receipt_path(@receipt)
  end

  private

  def transaction_params
    params.require(:transaction).permit(:name, :weight_value, :weight_unit, :price, :count, :weight, :raw, :item_id).merge({user: current_user})
  end
end