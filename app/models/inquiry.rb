class Inquiry
  include ActiveModel::Model

  attr_accessor :name, :email, :contents, :user_id, :utf8, :authenticity_token, :commit

  validates :name, presence: true
  validates :email, length: {maximum:255},
                    format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}
  validates :contents, presence: true
end
