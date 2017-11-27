class Store < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :receipts, inverse_of: :store, dependent: :nullify
  has_many :locations, inverse_of: :store, dependent: :nullify
  belongs_to :submission, required: false
  after_create :accept_submission

  def name_and_postal_code
    self.name + ' - ' + self.postal_code.to_s
  end

  def self.fuzzy_search(query = nil)
    if query
      Store.search(fuzzy_query(query)).records
    else
      Store.limit(6)
    end
  end

  def self.fuzzy_query(query)
    {
      query: {
        match_phrase_prefix: {
          name_and_postal_code: {
            query: query,
            slop: 3,
            max_expansions: 30
          }
        }
      }
    }
  end

  def as_indexed_json(options={})
    self.as_json(methods: :name_and_postal_code, only: :name_and_postal_code)
  end

  def accept_submission
    self.submission && self.submission.accepted!
  end
end
