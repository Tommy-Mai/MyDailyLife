FactoryBot.define do
  factory :usage_history do
    user_id { 1 }
    login_at { "2020-11-26 11:07:12" }
    logout_at { "2020-11-26 11:07:12" }
    timeout { false }
    action_count { 1 }
  end
end
