class AssociateSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_reference :stores, :submission
    add_reference :items, :submission
  end
end
