class AddIconSmToSections < ActiveRecord::Migration
  def change
    add_column :sections, :icon_sm, :string
  end
end
