# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :meal_tasks, foreign_key: "user_id", dependent: :destroy
  has_many :tasks, foreign_key: "user_id", dependent: :destroy
  has_many :task_tags, foreign_key: "user_id", dependent: :destroy
  has_many :usage_histories, foreign_key: "user_id"

  has_one_attached :image_name
  before_create :default_image

  with_options on: :create do |create|
    create.validates :name, presence: true
    create.validates :email, presence: true
    create.validates :password, presence: true
    create.validates :password_confirmation, presence: true
  end

  with_options length: { maximum: 30 } do
    validates :name
  end

  validates :email, { uniqueness: true }

  private

  def default_image
    self.image_name.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'user_default.jpg')), filename: 'user_default.jpg', content_type: 'image/jpg') unless self.image_name.attached?
  end
end
