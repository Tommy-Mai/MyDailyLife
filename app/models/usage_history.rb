# frozen_string_literal: true

class UsageHistory < ApplicationRecord
  has_one :user

  validates :user_id, { presence: true }
end
