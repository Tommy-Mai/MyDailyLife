class CreateUserMemos < ActiveRecord::Migration[5.2]
  def change
    create_table :user_memos do |t|
      t.string :name, :null => false, :limit => 30
      t.text :description
      t.integer :user_id, :null => false
      t.boolean :protected, :null => false, :default => false

      t.timestamps
    end
  end
end
