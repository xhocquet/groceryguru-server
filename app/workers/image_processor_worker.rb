class ImageProcessorWorker
  include Sidekiq::Worker

  def perform(receipt_id)
    Receipt.find(receipt_id).process_text!
  end
end