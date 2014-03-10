class RemoveUniversityFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :university, :string
  end
end
