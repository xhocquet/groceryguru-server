module Parsers
  class Generic
    def self.return_transactions(receipt)
      @receipt = receipt

      transactions = []

      @receipt.lines.each_with_index do |line, index|
        next if line.strip.blank?

        price = line.match(/(\$?\d{1,2}\.\d{1,2})(?!.*\$?\d{1,2}\.\d{1,2})/).to_s.presence
        price.gsub!(/\D/,'') if price.present?

        if line.match(/(\w* \w*)/).to_s.presence
          item = Item.fuzzy_search(line.match(/(\w* \w*)/).to_s.presence).records.first
        end

        transactions << {
          raw: line,
          line_number: index+1,
          user_id: @receipt.user.id,
          price_cents: price,
          receipt_id: @receipt.id,
          item: item
        }
      end

      transactions
    end
  end
end