FactoryBot.define do
  factory :meal_task do
    name { 'テスト投稿' }
    date { Time.zone.now }
    time { Time.zone.now }
    meal_tag_id { 1 }
    description { "test" }
    with_whom { "with" }
    where { "where" }
    user
  end
end
