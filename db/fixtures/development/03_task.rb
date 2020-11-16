# frozen_string_literal: true

MealTask.seed_once(
  :id,
  {
    id: 1,
    name: "MyDailyLifeへようこそ",
    description: "140文字まで詳細を記入できます。",
    meal_tag_id: 1,
    user_id: 2,
    with_whom: "任意で記入",
    where: "任意で記入",
    time: '09:00:00',
    date: '2020-11-05 00:00:00'
  }
)
