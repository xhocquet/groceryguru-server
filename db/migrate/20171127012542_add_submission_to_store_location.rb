class AddSubmissionToStoreLocation < ActiveRecord::Migration[5.1]
  def change
    add_reference :store_locations, :submission
  end
end
