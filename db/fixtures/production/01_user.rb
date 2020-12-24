# frozen_string_literal: true

User.seed_once(
  :id,
  {
    id: 1,
    name: "テストユーザー",
    email: 'sample@example.com',
    admin: false,
    password: 'test',
    password_confirmation: 'test',
    protected: true
  },
  {
    id: 2,
    name: "管理者",
    email: ENV[PRODUCTION_SEED_ADMIN_EMAIL],
    admin: true,
    password: ENV[PRODUCTION_SEED_ADMIN_PASSWORD],
    password_confirmation: ENV[PRODUCTION_SEED_ADMIN_PASSWORD],
    protected: true
  }
)
