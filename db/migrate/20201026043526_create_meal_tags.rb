class CreateMealTags < ActiveRecord::Migration[5.2]
  def change
    create_table :meal_tags do |t|
      t.string :name, :null => false
    end
  end
end
