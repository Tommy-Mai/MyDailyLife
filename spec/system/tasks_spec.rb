require 'rails_helper'

describe 'その他タスク管理機能', :type => :system do
  
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

  describe "その他タスク表示機能" do

    context "ユーザーAがログインしているとき" do
      let(:login_user) { user_a }

      it 'ユーザーAが作成したその他タスクが表示される' do
        # ユーザーAのユーザーページ(その他タスク)へ移動
        visit "/users/#{user_a.id}/other_tasks"
        expect(page).to have_content '最初のその他タスク'

        # 日別タスク一覧へ移動
        visit "/calendar/show/other_tasks?start_date=#{task_a.date.strftime('%Y-%m-%d')}"
        expect(page).to have_content '最初のその他タスク'

        # task_tag_id:1のタグの一覧ページへ移動
        visit "/task_tags/1"
        expect(page).to have_content '最初のその他タスク'

        # 月別カレンダーへ移動,ユーザーAが登録したその他タスクがカウントされていることを確認
        visit "/calendar/index?start_date=#{task_a.date.strftime('%Y-%m-%d')}"
        expect(page).to have_content 'その他 1'

        # ユーザーAが作成したタスクの詳細画面に移動
        visit task_path(task_a)
        expect(page).to have_content 'その他タスクテスト投稿'
      end
    end

    context "ユーザーBがログインしているとき" do
      let(:login_user) { user_b }

      it "ユーザーAが作成したタスクが表示されない" do
        # ユーザーBのユーザーページ(その他タスク)へ移動
        visit "/users/#{user_b.id}/other_tasks"
        expect(page).not_to have_content '最初のその他タスク'

        # task_tag_id:1のタグの一覧ページへ移動
        visit "/task_tags/1"
        expect(page).not_to have_content '最初のその他タスク'

        # 日別タスク一覧へ移動
        visit "/calendar/show/other_tasks?start_date=#{task_a.date.strftime('%Y-%m-%d')}"
        expect(page).not_to have_content '最初のその他タスク'

        # 月別カレンダーへ移動,ユーザーAが登録した食事タスクがカウントされていないことを確認
        visit "/calendar/index?start_date=#{task_a.date.strftime('%Y-%m-%d')}"
        expect(page).not_to have_content 'その他 1'

        # ユーザーAが作成したタスクの詳細画面に移動
        visit "/tasks/#{task_a.id}"
        within '.flash' do
          expect(page).to have_content '存在しないタスクです。'
        end
      end
    end

  end


  describe '新規その他タスク作成機能' do
    let(:login_user) { user_a }

    describe "その他タグを選択してタスクを作成" do
      before do
        visit new_task_path
        fill_in 'task_name',	:with => task_name
        fill_in 'task_description',	:with => task_description
        select '映画', :from => 'タグ'
        click_button '登録する'
      end

      context "新規作成画面で「タイトル」を入力したとき" do
        let(:task_name) { '新規その他タスク作成のテストを書く' }
        let(:task_description) { "その他タスク新規作成テスト" }

        it '正常に登録される' do
          expect(page).to have_selector '.flash', :text => '新規その他タスク作成のテストを書く'
        end

        it 'ユーザーAが新規作成した食関連タスクが表示される' do
          # ユーザーAが作成したタスクの詳細画面に移動
          expect(page).to have_content "その他タスク新規作成テスト"

          visit "/users/#{user_a.id}/other_tasks"
          expect(page).to have_content '最初のその他タスク'

          # 日別タスク一覧へ移動
          visit "/calendar/show/other_tasks?start_date=#{task_a.date.strftime('%Y-%m-%d')}"
          expect(page).to have_content '新規その他タスク作成のテストを書く'

          # task_tag_id:1のタグの一覧ページへ移動
          visit "/task_tags/1"
          expect(page).to have_content '新規その他タスク作成のテストを書く'

          # 月別カレンダーへ移動,ユーザーAが登録した食事タスクがカウントされていることを確認
          visit "/calendar/index?start_date=#{task_a.date.strftime('%Y-%m-%d')}"
          expect(page).to have_content 'その他 2'
        end
      end

      context "新規その他作成画面で「タイトル」を入力しなかったとき" do
        let(:task_name) { '' }
        let(:task_description) { "" }

        it 'エラーとなる' do
          within '.form-error' do
            expect(page).to have_content 'タイトルを入力してください'
          end
        end
      end

      context "新規その他作成画面で「詳細」が字数オーバーのとき" do
        let(:task_name) { '詳細が字数オーバー' }
        let(:task_description) { "オーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバー" }

        it 'エラーとなる' do
          within '.form-error' do
            expect(page).to have_content '詳細は140文字以内で入力してください'
          end
        end
      end

    end

    context "新規作成画面で「タグ」を選択しなかったとき" do
      before do
        visit new_task_path
        fill_in 'task_name',	:with => task_name
        fill_in 'task_description',	:with => task_description
        select '選択してください', :from => 'タグ'
        click_button '登録する'
      end

      let(:task_name) { 'タグを選択しない' }
      let(:task_description) { "" }

      it 'エラーとなる' do
        within '.form-error' do
          expect(page).to have_content 'タグを選択してください'
        end
      end
    end

  end

end
