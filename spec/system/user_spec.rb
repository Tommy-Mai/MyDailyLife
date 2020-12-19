require 'rails_helper'

describe 'ユーザー管理機能', :type => :system do

  describe "ユーザー新規登録画面で" do
    before do
      visit new_user_path
    end

    context "ユーザーAの登録が成功して" do
      before do
        fill_in "user[name]", :with => 'ユーザーA'
        fill_in "user[email]", :with => 'a@example.com'
        fill_in "user[password]", :with => 'password'
        fill_in "user[password_confirmation]", :with => 'password'
        click_button '登録する'
      end
      it '新規登録成功のflashが表示される' do
        expect(page).to have_content 'a@example.com'
        within '.flash' do
          expect(page).to have_content 'ユーザー「ユーザーA」を登録しました。'
        end
      end
    end

    describe "入力フォームに" do
      context "入力がない時" do
        before do
          click_button '登録する'
        end

        it 'エラー文が表示される' do
          expect(page).to have_content 'パスワードを入力してください'
          expect(page).to have_content 'ユーザー名を入力してください'

          expect(page).to have_content 'メールアドレスを入力してください'
          expect(page).to have_content '確認用パスワードを入力してください'
        end
      end

      context "メールアドレスが既存のアカウントと重複している時" do
        before do
          FactoryBot.find_or_create(:user, :name => 'ユーザーA', :email => 'a@example.com', :password => 'password', :admin => true)
          fill_in "user[name]", :with => 'ユーザー'
          fill_in "user[email]", :with => 'a@example.com'
          fill_in "user[password]", :with => 'password'
          fill_in "user[password_confirmation]", :with => 'password'
          click_button '登録する'
        end

        it '適切なエラー文が表示される' do
          within '.form-error' do
            expect(page).to have_content 'メールアドレス：すでに使用されているか、無効なメールアドレスです'
          end
        end
      end

      context "パスワードと確認用パスワードの入力が一致しない時" do
        before do
          fill_in "user[name]", :with => 'ユーザー'
          fill_in "user[email]", :with => 'a@example.com'
          fill_in "user[password]", :with => 'password'
          fill_in "user[password_confirmation]", :with => 'error'
          click_button '登録する'
        end
        it '適切なエラー文が表示される' do
          within '.form-error' do
            expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
          end
        end
      end

    end

    describe "テストユーザーとしてログインボタンを押したら" do
      before do
        FactoryBot.find_or_create(:user, :name => 'テストユーザー', :email => 'sample@example.com', :password => 'test', :password_confirmation => 'test', :admin => false)
      end

      it 'テストユーザーの詳細ページへ遷移する' do
        click_button 'テストユーザーとしてログイン'
        expect(page).to have_content 'sample@example.com'

        within '.flash' do
          expect(page).to have_content 'ログインしました。'
        end
      end
    end
    
  end

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
            expect(page).to have_content user_a.name
            expect(page).to have_content '今日のタスク'
            expect(page).to have_content 'タグ一覧'
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
            expect(page).to have_content user_b.name
            expect(page).to have_content '今日のタスク'
            expect(page).to have_content 'タグ一覧'
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
          expect(page).not_to have_content '今日のタスク'
          expect(page).not_to have_content 'タグ一覧'
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

    context "emailを入力しないとき、" do
      before do
        fill_in 'session_password',	:with => 'password'
        click_button 'ログイン'
      end

      it "エラーとなる" do
        within '.flash' do
          expect(page).to have_content 'メールアドレスまたはパスワードが間違っています。'
        end
      end
    end

    context "passwordを入力しないとき、" do
      before do
        fill_in 'session_email',	:with => 'email@sample.com'
        click_button 'ログイン'
      end

      it "エラーとなる" do
        within '.flash' do
          expect(page).to have_content 'メールアドレスまたはパスワードが間違っています。'
        end
      end
    end

  end

end
