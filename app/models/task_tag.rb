# frozen_string_literal: true

class TaskTag < ApplicationRecord
  belongs_to :user
  has_many :tasks, foreign_key: "task_tag_id", dependent: :destroy

  scope :recent, -> { order(created_at: :desc) }

  validates :name, uniqueness: { scope: :user }, presence: true, length: { maximum: 30 }
end
