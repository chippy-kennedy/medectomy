class AddIconLgToSections < ActiveRecord::Migration
  def change
    add_column :sections, :icon_lg, :string
  end
end
