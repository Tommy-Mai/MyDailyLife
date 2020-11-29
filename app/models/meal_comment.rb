class MealComment < ApplicationRecord
  has_one :user
  has_one :meal_task

  has_one_attached :image, dependent: :destroy

  validates :comment, { length: { maximum: 140 } }
  # validates :comment, presence: true, if: :image_empty?
  # validates :image, presence: true, if: :comment_empty?

  # def comment_empty?
  #   comment == nil
  # end

  # def image_empty?
  #   image == nil
  # end

end
