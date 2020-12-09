# frozen_string_literal: true

MealTask.seed_once(
  :id,
  {
    id: 1,
    name: "MyDailyLifeへようこそ",
    description: "詳細は140文字まで登録できます。\n・「タイトル・どこで・誰と」は30文字までです。",
    meal_tag_id: 1,
    user_id: 1,
    with_whom: "任意で記入",
    where: "任意で記入",
    time: Date.current,
    date: Date.current,
    protected: true
  }
)
