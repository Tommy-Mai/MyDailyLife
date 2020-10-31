class MealTask < ApplicationRecord
  belongs_to :meal_tag

  with_options presence: true do
    validates :name
    validates :date
    validates :meal_tag_id
    validates :user_id
  end

  with_options length: {maximum: 30} do
    validates :name
    validates :with_whom
    validates :where
  end

  validates :description, {length: {maximum: 140}}
  
end
