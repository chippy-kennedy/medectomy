class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_primary
      t.string :email_secondary
      t.string :current_level

      t.timestamps
    end
  end
end
