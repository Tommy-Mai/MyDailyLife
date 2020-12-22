class CreateTaskTags < ActiveRecord::Migration[5.2]
  def change
    create_table :task_tags do |t|
      t.string :name, :null => false, :limit => 30
      t.integer :user_id, :null => false
      t.boolean :protected, :null => false, :default => false

      t.timestamps
    end
  end
end
