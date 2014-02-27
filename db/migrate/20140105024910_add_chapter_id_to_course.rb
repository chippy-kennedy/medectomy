class AddChapterIdToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :chapter_id, :integer
  end
end
