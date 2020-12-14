FactoryBot.define do
  factory :inquiry do
    name { "メイラーSpec" }
    email { 'mailer@spec.com' }
    contents { "送信したメールの内容を確認するテスト" }
    user_id { 1 }
  end
end
