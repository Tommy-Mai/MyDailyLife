FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    email { "test1@example.com" }
    password_digest { "password" }
    password { "password" }
    password_confirmation { "password" }
    image_name { "" }
    admin { false }
  end
end
