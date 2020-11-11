require 'rails_helper'

describe '食関連タスク管理機能', type: :system do

  before do
  # 食関連タグの作成
    FactoryBot.find_or_create(:meal_tag)
    FactoryBot.find_or_create(:meal_tag, id: 2, name: "昼食")
    FactoryBot.find_or_create(:meal_tag, id: 3, name: "夕食")
    FactoryBot.find_or_create(:meal_tag, id: 4, name: "間食")
    FactoryBot.find_or_create(:meal_tag, id: 5, name: "飲酒")
    FactoryBot.find_or_create(:meal_tag, id: 6, name: "お薬")
    FactoryBot.find_or_create(:meal_tag, id: 7, name: "サプリメント")
  end

  # ユーザーをletで定義
  let(:user_a) { FactoryBot.find_or_create(:user, name: 'ユーザーA', email: 'a@example.com', password: 'password', admin: true ) }
  let(:user_b) { FactoryBot.find_or_create(:user, name: 'ユーザーB', email: 'b@example.com', password: 'password', admin: false ) }
  
  # 作成者がユーザーAである食関連タスクを作成する
  let!(:task_a) { FactoryBot.find_or_create(:meal_task, id: 1, name: '最初の食事タスク',description: '食事タスクテスト投稿', user: user_a, meal_tag_id: 1, date: Time.zone.now.strftime('%Y-%m-%d 00:00:00')) }
  
  before do
    # letで定義したユーザーでログインする
    visit login_path
    fill_in 'session_email',	with: login_user.email
    fill_in 'session_password',	with: login_user.password
    click_button 'ログイン'
  end


  describe "食事タスク表示機能" do

    context "ユーザーAがログインしているとき" do
      let(:login_user) { user_a }
      
      it 'ユーザーAが作成した食関連タスクが表示される' do
        # 全タスク一覧画面
        expect(page).to have_content '最初の食事タスク'
  
        # ユーザーAのユーザーページへ移動
        visit user_path(user_a)
        expect(page).to have_content '最初の食事タスク'
  
        # 日別タスク一覧へ移動＊保留
        visit "/calendar/show?start_date=#{task_a.date.strftime('%Y-%m-%d')}"
        expect(page).to have_content '最初の食事タスク'
        
        # meal_tag_id:1のタグの一覧ページへ移動
        visit "/meal_tags/1/index"
        expect(page).to have_content '最初の食事タスク'
  
        # ユーザーAが作成したタスクの詳細画面に移動
        visit meal_task_path(task_a)
        expect(page).to have_content '食事タスクテスト投稿'

        # 月別カレンダーへ移動,ユーザーAが登録した食事タスクがカウントされていることを確認
        visit "/calendar/index?start_date=#{task_a.date.strftime('%Y-%m-%d')}"
        expect(page).to have_content '食事タスク 1個'
      end
    end

    context "ユーザーBがログインしているとき" do
      let(:login_user) { user_b }

      it "ユーザーAが作成したタスクが表示されない" do
        # 全タスク一覧画面
        expect(page).not_to have_content '最初の食事タスク'

        # ユーザーBのユーザーページへ移動
        visit user_path(user_b)
        expect(page).not_to have_content '最初の食事タスク'

        # meal_tag_id:1のタグの一覧ページへ移動
        visit "/meal_tags/1/index"
        expect(page).not_to have_content '最初の食事タスク'

        # 日別タスク一覧へ移動
        visit "/calendar/show?start_date=#{task_a.date.strftime('%Y-%m-%d')}"
        expect(page).not_to have_content '最初の食事タスク'

        # 月別カレンダーへ移動,ユーザーAが登録した食事タスクがカウントされていないことを確認
        visit "/calendar/index?start_date=#{task_a.date.strftime('%Y-%m-%d')}"
        expect(page).not_to have_content '食事タスク 1個'

        # ユーザーAが作成したタスクの詳細画面に移動
        visit meal_task_path(task_a)
        expect(page).to have_content '存在しないタスクです。'
      end
    end

  end


  describe '新規食事タスク作成機能' do
    let(:login_user) {user_a}

    describe "食事タグを選択してタスクを作成" do
      before do
        visit new_meal_task_path
        fill_in 'meal_task_name',	with: meal_task_name
        fill_in 'meal_task_description',	with: meal_task_description
        select '朝食', from: 'タグ'
        click_button '登録する'
      end

      context "新規作成画面で「タイトル」を入力したとき" do
        let(:meal_task_name) { '新規作成のテストを書く' } 
        let(:meal_task_description) { "" } 

        it '正常に登録される' do
          expect(page).to have_selector '.flash', text: '新規作成のテストを書く'  
        end
      end

      context "新規作成画面で「タイトル」を入力しなかったとき" do
        let(:meal_task_name) { '' } 
        let(:meal_task_description) { "" } 

        it 'エラーとなる' do
          within '.form-error' do
            expect(page).to have_content 'タイトルを入力してください'  
          end
        end
      end

      context "新規作成画面で「食事内容」が字数オーバーのとき" do
        let(:meal_task_name) { '食事内容が字数オーバー' } 
        let(:meal_task_description) { "オーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバー" } 

        it 'エラーとなる' do
          within '.form-error' do
            expect(page).to have_content '食事内容は140文字以内で入力してください'  
          end
        end
      end
        
    end
    

    context "新規作成画面で「タグ」を選択しなかったとき" do
      before do
        visit new_meal_task_path
        fill_in 'meal_task_name',	with: meal_task_name
        fill_in 'meal_task_description',	with: meal_task_description
        select '選択してください', from: 'タグ'
        click_button '登録する'
      end

      let(:meal_task_name) { 'タグを選択しない' } 
      let(:meal_task_description) { "" } 

      it 'エラーとなる' do
        within '.form-error' do
          expect(page).to have_content 'タグを入力してください'  
        end
      end
    end

  end

end