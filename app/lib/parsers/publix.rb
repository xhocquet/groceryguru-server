module Parsers
  class Publix
    def self.return_transactions(receipt)
      @receipt = receipt
      double_line_buffer = []
      transactions = []

      @receipt.text.split("\n").each_with_index do |line, index|
        if line.strip.blank?
          double_line_buffer = []
          next
        end

        double_line_buffer << line
        # Match for price/tax: 12.39 t F
        if line.match(/(\d+\.\d+) (\w)? ?(\w)?$/)
          current_line = double_line_buffer.join("\n")
          item = Item.fuzzy_search(current_line.match(/(\w* \w*)/)[1]).records.first

          transactions << {
            raw: current_line,
            line_number: index+1,
            user_id: @receipt.user.id,
            receipt_id: @receipt.id,
            item: item,
          }

          double_line_buffer = []
        end
      end

      transactions
    end
  end
end