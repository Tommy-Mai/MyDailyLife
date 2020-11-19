FactoryBot.define do
  factory :task_tag do
    id { 1 }
    name { "テストタグ" }
    user_id { 1 }
  end
end
