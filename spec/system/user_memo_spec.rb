require 'rails_helper'

describe "メモ管理機能テスト", :type => :system  do
  # ユーザーをletで定義
  let(:user_a) { FactoryBot.find_or_create(:user, :name => 'ユーザーA', :email => 'a@example.com', :password => 'password', :admin => true) }
  let(:user_b) { FactoryBot.find_or_create(:user, :name => 'ユーザーB', :email => 'b@example.com', :password => 'password', :admin => false) }

  # メモを用意する
  let!(:memo_a) { FactoryBot.create(:user_memo,:name => '最初のメモ（ユーザーA）', :description => 'メモテスト投稿', :user => user_a) }
  let!(:memo_b) { FactoryBot.create(:user_memo,:name => 'ユーザーBのメモ', :description => 'ユーザーB', :user => user_b) }

  before do
    # letで定義したユーザーでログインする
    visit login_path
    fill_in 'session_email',	:with => login_user.email
    fill_in 'session_password',	:with => login_user.password
    click_button 'ログイン'
  end

  describe "ユーザーAがログインしているとき" do
    let(:login_user) { user_a }
    before do
      visit "/users/#{user_a.id}/memos"
    end

    describe "メモ表示機能で" do
      it 'ユーザーAが作成したメモが表示される' do
        expect(page).to have_content '最初のメモ（ユーザーA）'
        find(:css, 'i.fas.fa-bars').click
        expect(page).to have_content 'メモテスト投稿'
      end
      
      it 'ユーザーBが作成したメモが表示されない' do
        expect(page).not_to have_content 'ユーザーBのメモ'
      end
    end

    describe "メモを削除ボタンを押すと" do
      it 'ユーザーAが作成した最初のメモが削除される' do
        find(:css, 'i.fas.fa-bars').click
        find(:css, 'i.fas.fa-trash-alt.memo_trash-btn').click
        timeout = Selenium::WebDriver::Wait.new(timeout: 60)
        timeout
        expect{
          wait = Selenium::WebDriver::Wait.new ignore: Selenium::WebDriver::Error::NoAlertPresentError
          wait.until { page.accept_confirm }
          within '.flash' do
            expect(page).to have_content 'メモを削除しました。'
          end
        }.to change(user_a.user_memos, :count).by(-1)
        visit "/users/#{user_a.id}/memos"
        expect(page).not_to have_content '最初のメモ（ユーザーA）'
      end
    end

    describe "メモ新規作成で" do
      before do
        click_link "新規メモ +"
      end

      context "正しく入力したとき" do
        before do
          fill_in name="name", :with => "メモ新規作成テスト"
          fill_in name="description",	:with => "新しくメモをつくる"
          click_button '保存する'
        end

        it '新規メモ作成成功のflashが表示される' do
          within '.flash' do
            expect(page).to have_content "新規メモ「メモ新規作成テスト」を登録しました。"
          end
        end
    
        it '新しく作成したメモが表示される' do
          expect(page).to have_content "メモ新規作成テスト"
          first(:css, 'i.fas.fa-bars').click
          expect(page).to have_content "新しくメモをつくる"
        end
      end

      context "正しく入力しなかったとき" do
        before do
          visit "/users/#{user_a.id}/memos"
          click_link "新規メモ +"
        end
        it 'エラー文が表示される' do
          click_button '保存する'
          expect(page.accept_confirm).to eq "エラー：メモを登録できませんでした。\n・タイトルが空白のメモは登録できません。"
        end
      end
    end

    describe "メモ編集で" do
      before do
        first(:css, 'i.fas.fa-bars').click
        first(:css, 'i.fas.fa-edit.memo_edit-btn').click
      end

      context "正しく入力したとき" do
        before do
          fill_in name="name", :with => "メモ編集テスト"
          fill_in name="description",	:with => "メモ編集完了"
          click_button '更新する'
        end

        it 'メモ編集成功のflashが表示され、編集したメモが表示される' do
          expect(page).to have_content "メモ編集テスト"
          expect(page).to have_content "メモ編集完了"
          within '.flash' do
            expect(page).to have_content "メモ「メモ編集テスト」を更新しました。"
          end
        end
      end

      context "正しく入力しなかったとき" do
        before do
          visit "/users/#{user_a.id}/memos"
          first(:css, 'i.fas.fa-bars').click
          first(:css, 'i.fas.fa-edit.memo_edit-btn').click
        end
        
        it 'エラー文が表示される' do
          fill_in name="name", :with => ""
          click_button '更新する'
          expect(page.accept_confirm).to eq "エラー：メモを更新できませんでした。\n・空白のメモは登録できません。"
        end
      end
    end

    describe "多数のメモが登録されている状態で" do
      before do
        FactoryBot.create_list(:user_memo, 20, name: '検索用ダミーメモ', description: 'ダミー投稿', user: user_a)
        visit "/users/#{user_a.id}/memos"
      end

      it "ページネーションが正しく表示される" do
        expect(page).to have_css('.pagination')
        expect(page).to have_content "全#{user_a.user_memos.count}件"
      end

      describe "メモ検索欄に" do
        before do
          find(:css, 'i.fas.fa-search-plus').click
        end

        context "タイトルを入れて検索して" do
          before do
            fill_in name="q[name_cont]", :with => "最初"
            click_button '検索'
          end

          it '正しく結果が表示される' do
            expect(page).to have_content '最初のメモ（ユーザーA）'
            first(:css, 'i.fas.fa-bars').click
            expect(page).to have_content 'メモテスト投稿'
            expect(page).not_to have_content "検索用ダミーメモ"
            expect(page).not_to have_css('.pagination')
            expect(page).to have_content "全1件"
          end
        end
        
        context "詳細を入れて検索して" do
          before do
            fill_in name="q[description_cont]",	:with => "ダミー"
            click_button '検索'
          end

          it '正しく結果が表示される' do
            expect(page).to have_content "検索用ダミーメモ"
            first(:css, 'i.fas.fa-bars').click
            expect(page).to have_content "ダミー投稿"
            expect(page).not_to have_content '最初のメモ（ユーザーA）'
            expect(page).to have_css('.pagination')
            expect(page).to have_content "全20件"
          end
        end
      end
    end
    

  end
end
