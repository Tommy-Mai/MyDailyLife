# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :meal_tasks, :foreign_key => "user_id"

  with_options :presence => true do
    validates :name
    validates :email
    validates :password
    validates :password_confirmation
  end

  with_options :length => { :maximum => 30 } do
    validates :name
  end

  validates :email, { :uniqueness => true }
  validates :password, :length => { :minimum => 6 }
end
