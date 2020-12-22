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
    email: 'adminuser@development.com',
    admin: true,
    password: 'password',
    password_confirmation: 'password',
    protected: true
  }
)
