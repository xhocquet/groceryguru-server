module Parsers
  class Base
    def initialize(receipt)
      @receipt = receipt
    end

    def process
      @receipt.text.split("\n").each_with_index do |line, index|
        next if line.strip.blank?

        price = line.match(/(\$?\d{1,2}\.\d{1,2})/).to_s.presence || nil
        @receipt.transactions.build raw: line, line_number: index+1, user: @receipt.user, price: price
      end
    end
  end
end