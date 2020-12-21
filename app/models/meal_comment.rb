# frozen_string_literal: true

class MealComment < ApplicationRecord
  has_one :user
  has_one :meal_task

  has_one_attached :image, dependent: :destroy

  validates :comment, { length: { maximum: 140 } }
end
