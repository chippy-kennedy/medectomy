class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :graduation_year, :integer
    add_column :users, :degree, :string
  end
end
