class ChangeDatatypeDateOfMealtask < ActiveRecord::Migration[5.2]
  def up
    change_column :meal_tasks, :date, :datetime
  end

  def down
    change_column :meal_tasks, :date, :date
  end
end
