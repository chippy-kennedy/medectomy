class AddAncestryToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :ancestry, :string
  end
end
