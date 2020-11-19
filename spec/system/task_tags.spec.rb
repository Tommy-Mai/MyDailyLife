require 'rails_helper'

describe "その他タグ管理機能", :type => :system  do
    # ユーザーをletで定義
    let(:user_a) { FactoryBot.find_or_create(:user, :name => 'ユーザーA', :email => 'a@example.com', :password => 'password', :admin => true) }
    let(:user_b) { FactoryBot.find_or_create(:user, :name => 'ユーザーB', :email => 'b@example.com', :password => 'password', :admin => false) }

    before do
      # その他タグの作成
      FactoryBot.find_or_create(:task_tag, :id => 1, :name => "映画", :user_id => user_a.id)
      FactoryBot.find_or_create(:task_tag, :id => 2, :name => "ドラマ", :user_id => user_b.id)
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

    describe "その他タグ表示機能" do
      context "ユーザーAがログインしているとき" do
        let(:login_user) { user_a }

        it 'ユーザーAが作成したその他タグが表示される' do
          # ユーザーAが作成したその他タグ「映画」のページに移動
          visit task_tag_path(id: 1)
          expect(page).to have_content '「映画」一覧'
          expect(page).to have_content '最初のその他タスク'

          # ユーザーAが作成したその他タグ一覧ページに移動
          visit task_tags_path
          expect(page).to have_content 'タグ一覧'
          expect(page).to have_content '映画'
          expect(page).not_to have_content '← 戻る'
        end

        it '正しく戻るボタンが表示される' do
          # その他タグ一覧ページにクエリパラメータ付きで移動
          # task_tagのidが渡された場合
          visit "/task_tags?task_tag=1"
          expect(page).to have_content '← 「映画」一覧に戻る'
          # state_dateが渡された場合
          visit "/task_tags?start_date=2020-11-19"
          expect(page).to have_content '← 日別一覧に戻る'
        end
      end

      context "ユーザーBがログインしているとき" do
        let(:login_user) { user_b }

        it 'ユーザーAが作成したその他タグが表示されない' do
          # ユーザーAが作成したその他タグ「映画」のページに移動
          visit task_tag_path(id: 1)
          within '.flash' do
            expect(page).to have_content '存在しないタグです。'
          end

          # ユーザーbが作成したその他タグ一覧ページに移動
          visit task_tags_path
          expect(page).to have_content 'タグ一覧'
          expect(page).to have_content 'ドラマ'
          expect(page).not_to have_content '映画'
          expect(page).not_to have_content '← 戻る'
        end
      end
      
    end
    
end

