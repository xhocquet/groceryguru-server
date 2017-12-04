class ReceiptParser
  def initialize(receipt)
    @receipt = receipt
  end

  def process
    @detected_store = detect_store
    @parser = detect_parser
    transaction_values = @parser.return_transactions(@receipt)
    Transaction.bulk_insert values: transaction_values
    true
  end

  private

  def detect_store
    @receipt.lines.each do |line|
      next if line.strip.blank?

      # Words 2 characters or more
      matches = line.downcase.match(/([\w\']{2,})/)

      matches && matches.captures.each do |string|
        results = Store::Location.fuzzy_search(string)

        if results.records.size > 0
          @receipt.store = results.records.first and return @receipt.store
        end
      end
    end
    nil
  end

  def detect_parser
    if @detected_store && class_exists?("::Parsers::#{@detected_store.name.downcase}")
      return "::Parsers::#{@detected_store.name.downcase}".constantize
    else
      return ::Parsers::Generic
    end
  end

  def class_exists?(class_name)
    begin
      klass = Module.const_get(class_name)
      return klass.is_a?(Class)
    rescue NameError
      return false
    end
  end
end