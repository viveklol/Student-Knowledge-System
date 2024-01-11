class AddAddedByAndAddedAtToNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :added_by, :string
    add_column :notes, :added_at, :datetime
  end
end
