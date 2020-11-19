FactoryBot.define do
  factory :task do
    name { "その他タスクのテスト投稿" }
    description { "MyText" }
    date { Time.zone.now }
    time { Time.zone.now }
    with_whom { "with" }
    where { "where" }
    task_tag_id { 1 }
    user_id { 1 }
  end
end
