class RemoveSectionIdFromSections < ActiveRecord::Migration
  def change
    remove_column :sections, :section_id, :integer
  end
end
