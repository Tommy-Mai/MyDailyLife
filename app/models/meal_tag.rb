class MealTag < ApplicationRecord
  has_many :meal_tasks, foreign_key: "meal_tag_id", dependent: :destroy
end
