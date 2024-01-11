class AddArchivedToCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :archived, :boolean,default: false
  end
end
