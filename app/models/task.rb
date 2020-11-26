# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  belongs_to :task_tag, optional: true

  scope :recent, -> { order(date: :desc, time: :desc) }

  with_options presence: true do
    validates :name
    validates :date
    validates :user_id
  end
  validates :task_tag_id, presence: { message: 'を選択してください' }

  with_options length: { maximum: 30 } do
    validates :name
    validates :with_whom
    validates :where
  end

  validates :description, { length: { maximum: 140 } }

  def start_time
    self.date
  end
end
