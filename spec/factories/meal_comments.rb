FactoryBot.define do
  factory :meal_comment do
    comment { "MyString" }
    image { "MyString" }
    user_id { 1 }
    task_id { 1 }
  end
end
