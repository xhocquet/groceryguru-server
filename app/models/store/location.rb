class Store::Location < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :store, inverse_of: :locations
  has_many :receipts, inverse_of: :store

  delegate :name, to: :store

  def serialized_location
    [self.name, self.postal_code.to_s].join(' - ')
  end

  def self.fuzzy_search(query = nil)
    if query
      Store::Location.search(fuzzy_query(query)).records
    else
      Store::Location.limit(6)
    end
  end

  def self.fuzzy_query(query)
    {
      query: {
        match_phrase_prefix: {
          serialized_location: {
            query: query,
            slop: 3,
            max_expansions: 30
          }
        }
      }
    }
  end

  def as_indexed_json(options={})
    self.as_json(methods: :serialized_location, only: :serialized_location)
  end

  def accept_submission
    self.submission && self.submission.accepted!
  end
end
