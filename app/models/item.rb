class Item < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :receipts
  has_one :receipt_transaction, class_name: "Transaction"
  belongs_to :mode
  belongs_to :group

  def name_and_mode
    [self.name, self.mode.try(:name).gsub(/\,/,'').gsub(/\s{2}/,' ')].compact.join(' ')
  end

  def self.basic_search(query = nil)
    if query
      items = Item.arel_table
      Item.where(items[:name].matches("%#{query}%")).order("LENGTH(items.name) ASC").limit(6)
    else
      Item.limit(6)
    end
  end

  def self.fuzzy_search(query = nil)
    if query
      Item.search(fuzzy_query(query))
    else
      Item.limit(6)
    end
  end

  def self.fuzzy_query(query)
    {
      query: {
        match_phrase_prefix: {
          name_and_mode: {
            query: query,
            slop: 3,
            max_expansions: 30
          }
        }
      }
    }
  end

  def as_indexed_json(options={})
    self.as_json(methods: [:name_and_mode], only: [:name_and_mode])
  end
end
