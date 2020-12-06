class CreateMealTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :meal_tasks do |t|
      t.string :name, :null => false, :limit => 30
      t.text :description
      t.datetime :date, :null => false
      t.integer :meal_tag_id, :null => false
      t.integer :user_id, :null => false
      t.string :with_whom, :limit => 30
      t.string :where, :limit => 30
      t.time :time, :null => false
      t.boolean :protected, :null => false, :default => false

      t.timestamps
    end
  end
end
