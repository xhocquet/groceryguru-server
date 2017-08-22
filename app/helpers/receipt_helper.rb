module ReceiptHelper
  def transactions_count(receipt)
    receipt.transactions.count
  end

  def completed_transactions_count(receipt)
    receipt.transactions.completed.count
  end

  def store_or_add_store(receipt)
    if receipt.store.present?
      @receipt.store.try(:name).try(:titleize)
    else
      link_to('Add Store', '#', class: 'button is-warning add-store-button') +
      (form_for receipt, html: { class: 'store-date-form store-form' } do
        (hidden_field 'receipt', :store_id, class: 'input') +
        (content_tag :input, '', class: 'input store-input is-hidden' )
      end)
    end
  end

  def completion_percentage(receipt)
    value = ((completed_transactions_count(receipt).to_f / transactions_count(receipt).to_f)*100)
    "#{value.round}%" unless value.infinite? || value.nan?
  end

  def date_or_add_date(receipt)
    if receipt.date.present?
      @receipt.date.try(:to_date).try(:to_formatted_s, :long)
    else
      (link_to 'Add Date', '#', class: 'button is-warning add-date-button') +
      (form_for receipt, html: { class: 'store-date-form date-form' } do
        text_field 'receipt', :date, class: 'input date-input is-hidden'
      end)
    end
  end

  def weight_text(transaction)
    if transaction.weight.present?
      Unit.new(transaction.weight).to_s
    else
      '-'
    end
  end
end
