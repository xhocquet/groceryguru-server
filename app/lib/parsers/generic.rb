module Parsers
  class Generic
    def self.return_transactions(receipt)
      @receipt = receipt

      transactions = []

      @receipt.text.split("\n").each_with_index do |line, index|
        next if line.strip.blank?

        price = line.match(/(\$?\d{1,2}\.\d{1,2})/).to_s.presence || nil

        transactions << { raw: line, line_number: index+1, user_id: @receipt.user.id, price: price, receipt_id: @receipt.id }
      end

      transactions
    end
  end
end