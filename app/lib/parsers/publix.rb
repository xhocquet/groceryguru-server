module Parsers
  class Publix < Generic
    def process
      double_line_buffer = []

      @receipt.text.split("\n").each_with_index do |line, index|
        if line.strip.blank?
          double_line_buffer = []
          next
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