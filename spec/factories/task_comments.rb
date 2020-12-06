FactoryBot.define do
  factory :task_comment do
    comment { "MyString" }
    image_exist { false }
    user_id { 1 }
    tasks_id { 1 }
  end
end
