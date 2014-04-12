class AddSectiondIdToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :section_id, :integer
  end
end
