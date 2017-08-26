module Parsers
  class Publix < Base
    def process
      double_line_buffer = []

      @receipt.text.split("\n").each_with_index do |line, index|
        if line.strip.blank?
          double_line_buffer = []
          next
        end

        if index < 5
          line.downcase.match(/([\w\']{2,})/).captures.each do |string|
            @receipt.store = Store.find_by_name(string)
          end
        end

        double_line_buffer << line
        # Match for price/tax: 12.39 t F
        if line.match(/(\d+\.\d+) (\w)? ?(\w)?$/)
          current_line = double_line_buffer.join("\n")
          @receipt.transactions.build raw: current_line, line_number: index+1, user: @receipt.user
          double_line_buffer = []
        end
      end
    end
  end
end