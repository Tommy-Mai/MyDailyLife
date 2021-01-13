# frozen_string_literal: true

class MealTag < ApplicationRecord
  has_many :meal_tasks, foreign_key: "meal_tag_id", dependent: :destroy

  scope :number, -> { order(:id) }
end
