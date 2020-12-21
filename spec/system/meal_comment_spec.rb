require 'rails_helper'

describe "食事コメント管理機能テスト", :type => :system  do
  # ユーザーをletで定義
  let(:user_a) { FactoryBot.find_or_create(:user, :name => 'ユーザーA', :email => 'a@example.com', :password => 'password', :admin => true) }

  before do
    # 食関連タグの作成
    FactoryBot.create(:meal_tag)
  end

  # 作成者がユーザーAである食関連タスクを作成する
  let!(:task_a) { FactoryBot.create(:meal_task, :id => 1, :name => '最初の食事タスク', :description => '食事タスクテスト投稿', :user => user_a, :meal_tag_id => 1, :date => Time.zone.now) }

  before do
    # letで定義したユーザーでログインする
    visit login_path
    fill_in 'session_email',	:with => login_user.email
    fill_in 'session_password',	:with => login_user.password
    click_button 'ログイン'
  end

  describe "食事タスクのコメント表示機能" do
    # ユーザーAがtask_aのコメントを作成
    let!(:comment_a) { FactoryBot.create(:meal_comment, :comment => 'ユーザーAの食事タスクのコメント', :user_id => user_a.id, :task_id => task_a.id) }

    context "ユーザーAがログインしているとき" do
      let(:login_user) { user_a }

      before do
        visit meal_task_path(id: task_a.id)
      end

      it 'task_a詳細画面で作成した食事コメントが表示される' do
        expect(page).to have_content '最初の食事タスク'
        expect(page).to have_content 'ユーザーAの食事タスクのコメント'
        expect(page).to have_content comment_a.created_at.strftime('%Y-%m-%d')
        expect(page).to have_content comment_a.created_at.strftime('%H:%M')
      end
    end

  end
end