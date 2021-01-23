# frozen_string_literal: true

UserMemo.seed_once(
  :id,
  {
    id: 1,
    user_id: 1,
    name: 'メモ機能について',
    description: "このメモ機能は「タイトル」と「詳細」のみを記録するシンプルな機能です。\n「何時・どこで・誰と・経過」なども記録できる食事・その他タスク機能と違い、シンプルな記録機能にですので名前の通り「メモ」として覚えておきたい事柄を書き留めておくなどの用途にお使いいただくことに適しています。",
    protected: true
  }
)
