class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string :name
      t.integer :number
      t.string :directory
      t.string :icon_lg
      t.string :icon_sm

      t.timestamps
    end
  end
end
