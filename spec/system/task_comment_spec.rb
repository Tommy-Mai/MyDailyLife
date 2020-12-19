require 'rails_helper'

describe "その他コメント管理機能テスト", :type => :system  do
  # ユーザーをletで定義
  let(:user_a) { FactoryBot.find_or_create(:user, :name => 'ユーザーA', :email => 'a@example.com', :password => 'password', :admin => true) }

  before do
    # その他タグの作成
    FactoryBot.find_or_create(:task_tag, :id => 1, :name => "映画", :user_id => user_a.id)
  end

  # 作成者がユーザーAであるその他タスクを作成する
  let!(:task_a) { FactoryBot.find_or_create(:task, :id => 1, :name => '最初のその他タスク', :description => 'その他タスクテスト投稿', :user => user_a, :task_tag_id => 1, :date => Time.zone.now) }

  before do
    # letで定義したユーザーでログインする
    visit login_path
    fill_in 'session_email',	:with => login_user.email
    fill_in 'session_password',	:with => login_user.password
    click_button 'ログイン'
  end

  describe "その他タスクのコメント表示機能" do
    # ユーザーAがtask_aのコメントを作成
    let!(:comment_a) { FactoryBot.find_or_create(:task_comment, :comment => 'ユーザーAのその他タスクのコメント', :user_id => user_a.id, :task_id => task_a.id) }

    context "ユーザーAがログインしているとき" do
      let(:login_user) { user_a }

      before do
        visit task_path(id: task_a.id)
      end

      it 'task_a詳細画面で作成したその他コメントが表示される' do
        expect(page).to have_content '最初のその他タスク'
        expect(page).to have_content 'ユーザーAのその他タスクのコメント'
        expect(page).to have_content comment_a.created_at.strftime('%Y-%m-%d')
        expect(page).to have_content comment_a.created_at.strftime('%H:%M')
      end
    end

  end
end