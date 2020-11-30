class CreateTasksComments < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks_comments do |t|
      t.string :comment, :limit => 140
      t.boolean :image_exist, :null => false, :default =>  false
      t.integer :user_id, :null => false
      t.integer :task_id, :null => false

      t.timestamps
      t.index :user_id
      t.index :task_id
    end
  end
end
