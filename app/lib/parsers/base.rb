module Parsers
  class Base
    def initialize(receipt)
      @receipt = receipt
    end

    def process
      @receipt.text.split("\n").each_with_index do |line, index|
        next if line.strip.blank?
        @receipt.transactions.build raw: line, line_number: index+1, user: @receipt.user
      end
    end
  end
end