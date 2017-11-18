class Item < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :receipts
  has_one :receipt_transaction, class_name: "Transaction"
  belongs_to :group, required: false
  belongs_to :submission, required: false
  after_create :accept_submission

  def self.fuzzy_search(query = nil)
    if query
      Item.search(fuzzy_query(query)).records
    else
      Item.limit(6)
    end
  end

  def self.fuzzy_query(query)
    {
      query: {
        match_phrase_prefix: {
          name: {
            query: query,
            slop: 3,
            max_expansions: 30
          }
        }
      }
    }
  end

  def as_indexed_json(options={})
    self.as_json(only: [:name])
  end

  def accept_submission
    self.submission && self.submission.accepted!
  end
end
