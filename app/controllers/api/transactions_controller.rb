class Api::TransactionsController < Api::BaseController
  def delete_transactions
    transactions = Transaction.where(id: params.require(:transaction_ids))

    if transactions.destroy_all
      render status: 200, json: {
        message: "Successfully destroyed transactions.",
        transaction_ids: transactions.ids
      }.to_json
    else
      render status: 400
    end
  end
end