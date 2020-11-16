require 'rails_helper'

describe 'ユーザー管理機能', :type => :system do
  # ユーザーをletで定義
  let(:user_a) { FactoryBot.find_or_create(:user, :name => 'ユーザーA', :email => 'a@example.com', :admin => true) }
  let(:user_b) { FactoryBot.find_or_create(:user, :name => 'ユーザーB', :email => 'b@example.com', :admin => false) }

  describe "ユーザーログイン時" do
    before do
      # letで定義したユーザーでログインする
      visit login_path
      fill_in 'session_email',	:with => login_user.email
      fill_in 'session_password',	:with => login_user.password
      click_button 'ログイン'
    end

    describe "ヘッダー表示切り替え機能" do

      context "ユーザーAがログインしているとき" do
        let(:login_user) { user_a }

        it 'ヘッダーに「ユーザー管理」が表示される' do
          within '.header-menus' do
            expect(page).to have_content 'ユーザー管理'
          end
        end

        it "表示されるべきヘッダーが表示されている" do
          within '.header-menus' do
            expect(page).to have_content 'タスク検索'
            expect(page).to have_content 'ログアウト'
          end
        end
        it "不要なヘッダーが表示されない" do
          within '.header-menus' do
            expect(page).not_to have_content 'MyDailyLifeとは'
            expect(page).not_to have_content '新規登録'
            expect(page).not_to have_content 'ログイン'
          end
        end
      end

      context "ユーザーBがログインしているとき" do
        let(:login_user) { user_b }

        it 'ヘッダーに「ユーザー管理」が表示されない' do
          within '.header-menus' do
            expect(page).not_to have_content 'ユーザー管理'
          end
        end

        it "表示されるべきヘッダーが表示されている" do
          within '.header-menus' do
            expect(page).to have_content 'タスク検索'
            expect(page).to have_content 'ログアウト'
          end
        end
        it "不要なヘッダーが表示されない" do
          within '.header-menus' do
            expect(page).not_to have_content 'MyDailyLifeとは'
            expect(page).not_to have_content '新規登録'
            expect(page).not_to have_content 'ログイン'
          end
        end
      end

    end

  end

  describe "ログインしていないとき" do
    before do
      visit "/"
    end

    describe "ヘッダー表示切り替え機能" do

      it "表示されるべきヘッダーが表示されている" do
        within '.header-menus' do
          expect(page).to have_content 'MyDailyLifeとは'
          expect(page).to have_content '新規登録'
          expect(page).to have_content 'ログイン'
        end
      end
      it "ログイン時以外不要なヘッダーが表示されない" do
        within '.header-menus' do
          expect(page).not_to have_content 'タスク検索'
          expect(page).not_to have_content "ユーザー管理"
          expect(page).not_to have_content 'ログアウト'
        end
      end
    end

  end

  describe "ユーザーログイン機能" do
    before do
      visit login_path
    end

    context "emailを入力しない" do
      before do
        fill_in 'session_password',	:with => 'password'
        click_button 'ログイン'
      end

      it "エラーとなる" do
        within '.form-error' do
          expect(page).to have_content 'メールアドレスまたはパスワードが間違っています。'
        end
      end
    end

    context "passwordを入力しない" do
      before do
        fill_in 'session_email',	:with => 'email@sample.com'
        click_button 'ログイン'
      end

      it "エラーとなる" do
        within '.form-error' do
          expect(page).to have_content 'メールアドレスまたはパスワードが間違っています。'
        end
      end
    end

  end

end
