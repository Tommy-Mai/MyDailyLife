# frozen_string_literal: true

class TaskTag < ApplicationRecord
  belongs_to :user
  has_many :tasks, foreign_key: "task_tag_id", dependent: :destroy

  with_options presence: true do
    validates :name
  end

  with_options length: { maximum: 30 } do
    validates :name
  end
end
