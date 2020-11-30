class TasksComment < ApplicationRecord
  has_one :user
  has_one :task

  has_one_attached :image, dependent: :destroy

  validates :comment, { length: { maximum: 140 } }
end
