FactoryBot.define do
  factory :meal_task do
    name { 'テスト投稿' }
    date { Time.zone.now }
    time { Time.zone.now }
    description { "test" }
    with_whom { "with" }
    where { "where" }
    meal_tag_id { 1 }
    user_id { 1 }
  end
end
