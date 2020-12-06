class UserMemo < ApplicationRecord
  belongs_to :user

  scope :recent, -> { order(created_at: :desc) }

  with_options presence: :true do
    validates :name
    validates :user_id
  end

  with_options length: { maximum: 30 } do
    validates :name
  end
end
