class Store::Location < ApplicationRecord
  belongs_to :store, inverse_of: :locations
end
