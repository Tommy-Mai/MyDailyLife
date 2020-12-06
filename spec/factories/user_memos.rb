FactoryBot.define do
  factory :user_memo do
    name { "MyString" }
    description { "MyText" }
    user_id { 1 }
  end
end
