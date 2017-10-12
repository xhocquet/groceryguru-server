json.array! @receipts do |receipt|
  json.key receipt.id
  json.date receipt.date.try(:strftime, "%F")
  json.store receipt.store.try(:name).try(:titleize)
  json.completed receipt.completed
end