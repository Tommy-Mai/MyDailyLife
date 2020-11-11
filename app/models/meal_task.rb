class MealTask < ApplicationRecord
  belongs_to :user

  scope :recent, -> { order(date: :desc,time: :desc) }

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
  
  def start_time
    self.date
  end

end
