class Inquiry
  include ActiveModel::Model

  attr_accessor :name, :email, :contents, :user_id, :utf8, :authenticity_token, :commit

  validates :name, presence: true
  validates :contents, presence: true
end
