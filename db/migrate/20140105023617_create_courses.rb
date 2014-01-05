class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :description
      t.string :icon_lg
      t.string :icon_sm

      t.timestamps
    end
  end
end
