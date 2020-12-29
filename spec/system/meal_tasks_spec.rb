require 'rails_helper'

describe '食関連タスク管理機能', :type => :system do

  before do
    # 食関連タグの作成
    FactoryBot.create(:meal_tag)
    FactoryBot.create(:meal_tag, :id => 2, :name => "昼食")
    FactoryBot.create(:meal_tag, :id => 3, :name => "夕食")
    FactoryBot.create(:meal_tag, :id => 4, :name => "間食")
    FactoryBot.create(:meal_tag, :id => 5, :name => "飲酒")
    FactoryBot.create(:meal_tag, :id => 6, :name => "お薬")
    FactoryBot.create(:meal_tag, :id => 7, :name => "サプリメント")
  end

  # ユーザーをletで定義
  let(:user_a) { FactoryBot.find_or_create(:user, :name => 'ユーザーA', :email => 'a@example.com', :password => 'password', :admin => true) }
  let(:user_b) { FactoryBot.find_or_create(:user, :name => 'ユーザーB', :email => 'b@example.com', :password => 'password', :admin => false) }

  # 作成者がユーザーAである食関連タスクを作成する
  let!(:task_a) { FactoryBot.create(:meal_task, :id => 1, :name => '最初の食事タスク', :description => '食事タスクテスト投稿', :user => user_a, :meal_tag_id => 1, :date => Time.zone.now) }

  before do
    # letで定義したユーザーでログインする
    visit login_path
    fill_in 'session_email',	:with => login_user.email
    fill_in 'session_password',	:with => login_user.password
    click_button 'ログイン'
  end

  describe "食事タスク表示機能" do

    context "ユーザーAがログインしているとき" do
      let(:login_user) { user_a }

      it 'ユーザーAが作成した食関連タスクが表示される' do
        # ユーザーAのユーザーページ
        expect(page).to have_content '最初の食事タスク'

        # 日別タスク一覧へ移動
        visit "/calendar/show?start_date=#{task_a.date.strftime('%Y-%m-%d')}"
        expect(page).to have_content '最初の食事タスク'

        # meal_tag_id:1のタグの一覧ページへ移動
        visit "/meal_tags/1"
        expect(page).to have_content '最初の食事タスク'

        # 月別カレンダーへ移動,ユーザーAが登録した食事タスクがカウントされていることを確認
        visit "/calendar/index?start_date=#{task_a.date.strftime('%Y-%m-%d')}"
        expect(page).to have_content '食事タスク 1'

        # ユーザーAが作成したタスクの詳細画面に移動
        visit meal_task_path(task_a)
        expect(page).to have_content '食事タスクテスト投稿'
      end
    end

    context "ユーザーBがログインしているとき" do
      let(:login_user) { user_b }

      it "ユーザーAが作成したタスクが表示されない" do
        # ユーザーBのユーザーページ
        expect(page).not_to have_content '最初の食事タスク'

        # meal_tag_id:1のタグの一覧ページへ移動
        visit "/meal_tags/1"
        expect(page).not_to have_content '最初の食事タスク'

        # 日別タスク一覧へ移動
        visit "/calendar/show?start_date=#{task_a.date.strftime('%Y-%m-%d')}"
        expect(page).not_to have_content '最初の食事タスク'

        # 月別カレンダーへ移動,ユーザーAが登録した食事タスクがカウントされていないことを確認
        visit "/calendar/index?start_date=#{task_a.date.strftime('%Y-%m-%d')}"
        expect(page).not_to have_content '食事タスク 1'

        # ユーザーAが作成したタスクの詳細画面に移動
        visit meal_task_path(task_a)
        within '.flash' do
          expect(page).to have_content '存在しないタスクです。'
        end
      end
    end

  end

  describe '新規食事タスク作成機能' do
    let(:login_user) { user_a }

    describe "食事タグを選択してタスクを作成" do
      before do
        visit new_meal_task_path
        fill_in 'meal_task_name',	:with => meal_task_name
        fill_in 'meal_task_description',	:with => meal_task_description
        select '朝食', :from => 'タグ'
        click_button '登録する'
      end

      context "新規作成画面で「タイトル」を入力したとき" do
        let(:meal_task_name) { '新規作成のテストを書く' }
        let(:meal_task_description) { "食事タスク新規作成テスト" }

        it '正常に登録される' do
          expect(page).to have_selector '.flash', :text => '新規作成のテストを書く'
        end

        it 'ユーザーAが新規作成した食関連タスクが表示される' do
          # 全タスク一覧画面
          expect(page).to have_content '新規作成のテストを書く'

          # ユーザーAのユーザーページへ移動
          visit user_path(user_a)
          expect(page).to have_content '新規作成のテストを書く'

          # 日別タスク一覧へ移動
          visit "/calendar/show?start_date=#{task_a.date.strftime('%Y-%m-%d')}"
          expect(page).to have_content '新規作成のテストを書く'

          # meal_tag_id:1のタグの一覧ページへ移動
          visit "/meal_tags/1"
          expect(page).to have_content '新規作成のテストを書く'

          # ユーザーAが作成したタスクの詳細画面に移動
          visit meal_task_path(id: 2)
          expect(page).to have_content '食事タスク新規作成テスト'

          # 月別カレンダーへ移動,ユーザーAが登録した食事タスクがカウントされていることを確認
          visit "/calendar/index?start_date=#{task_a.date.strftime('%Y-%m-%d')}"
          expect(page).to have_content '食事タスク 2'
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

      context "新規作成画面で「詳細」が字数オーバーのとき" do
        let(:meal_task_name) { '詳細が字数オーバー' }
        let(:meal_task_description) { "オーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバーオーバー" }

        it 'エラーとなる' do
          within '.form-error' do
            expect(page).to have_content '詳細は140文字以内で入力してください'
          end
        end
      end

    end

    context "新規作成画面で「タグ」を選択しなかったとき" do
      before do
        visit new_meal_task_path
        fill_in 'meal_task_name',	:with => meal_task_name
        fill_in 'meal_task_description',	:with => meal_task_description
        select '選択してください', :from => 'タグ'
        click_button '登録する'
      end

      let(:meal_task_name) { 'タグを選択しない' }
      let(:meal_task_description) { "" }

      it 'エラーとなる' do
        within '.form-error' do
          expect(page).to have_content 'タグを選択してください'
        end
      end
    end

  end

  describe "ユーザーAのユーザー詳細ページの食事関連タブの検索欄で" do
    let(:login_user) { user_a }

    before do
      # 検証用タスク作成
      FactoryBot.create(:meal_task, :name => '日付選択検索正解タスク', :description => '日付検索テスト正解、詳細画面', :user => user_a, :meal_tag_id => 1, :date => Time.zone.now.next_month)
      FactoryBot.create(:meal_task, :name => 'タグ検索正解タスク', :description => '「昼食」タグ正解', :user => user_a, :meal_tag_id => 2, :date => '2020-12-10 00:00:00')
      FactoryBot.create(:meal_task, :name => 'タイトル指定検索テスト', :description => '「タイトル」指定検索の正解', :user => user_a, :meal_tag_id => 3, :date => '2020-12-10 00:00:00')
      FactoryBot.create(:meal_task, :name => '「詳細」指定の正解タスク', :description => '詳細指定検索用の投稿内容', :user => user_a, :meal_tag_id => 3, :date => '2020-12-10 00:00:00')
      FactoryBot.create(:meal_task, :name => 'タイトル「誰と」', :description => '「誰と」指定の正解', :user => user_a, :meal_tag_id => 3, :date => '2020-12-10 00:00:00', :with_whom => 'ABCDさん' )
      FactoryBot.create(:meal_task, :name => 'タイトル「どこで」', :description => '「どこで」指定の正解', :user => user_a, :meal_tag_id => 3, :date => '2020-12-10 00:00:00', :where => 'どこかで' )
      FactoryBot.create(:meal_task, :name => '複数条件絞り込み', :description => '「複数条件指定」正解のタスク', :user => user_a, :meal_tag_id => 7, :date => '2020-12-11 00:00:00')
      FactoryBot.create(:meal_task, :name => '複数条件絞り込み', :description => '「複数条件指定」ダミー(タグid違い)', :user => user_a, :meal_tag_id => 5, :date => '2020-12-11 00:00:00')
      FactoryBot.create(:meal_task, :name => '「複数条件指定」ダミー', :description => '「複数条件指定」ダミー(タイトル違い)', :user => user_a, :meal_tag_id => 7, :date => '2020-12-11 00:00:00')
      FactoryBot.create(:meal_task, :name => '複数条件絞り込み', :description => '「複数条件指定」ダミー(日付違い)', :user => user_a, :meal_tag_id => 7, :date => '2020-11-11 00:00:00')
    end
    
    before do
      # タスク作成後にユーザー詳細の食事関連タブにリダイレクト
      visit "/users/#{user_a.id}"
      find(:css, 'i.fas.fa-search-plus').click
      expect(page).to have_content '日付選択検索正解タスク'
      expect(page).to have_content '複数条件絞り込み'
    end

    context "日付を指定して検索して" do
      # 今日の日付(task_a)
      before do
        t1 = Time.zone.now
        t2 = Time.zone.now.next_month
        # から〜を指定
        select(t1.strftime("%Y"), from: "q[date_gteq(1i)]")
        select(t1.strftime("%-m"), from: "q[date_gteq(2i)]")
        select(t1.strftime("%-d"), from: "q[date_gteq(3i)]")
        # 〜までを指定
        select(t2.strftime("%Y"), from: "q[date_lteq_end_of_day(1i)]")
        select(t2.strftime("%-m"), from: "q[date_lteq_end_of_day(2i)]")
        select(t2.strftime("%-d"), from: "q[date_lteq_end_of_day(3i)]")
        click_button '検索'
      end

      it '正しく結果が表示される' do
        expect(page).not_to have_content '複数条件絞り込み'
        expect(page).not_to have_content '2020/11/11'
        expect(page).not_to have_content 'タイトル「どこで」'
        expect(page).not_to have_content 'タイトル「誰と」'
        expect(page).not_to have_content '「詳細」指定の正解タスク'
        expect(page).not_to have_content 'タイトル指定検索テスト'
        expect(page).not_to have_content 'タグ検索正解タスク'
        expect(page).to have_content '最初の食事タスク'
        expect(page).to have_content '日付選択検索正解タスク'
        expect(page).to have_content Time.zone.now.next_month.strftime('%Y/%m/%d')
        click_link '日付選択検索正解タスク'
        expect(page).to have_content '日付検索テスト正解、詳細画面'
      end
    end

    context "タグを指定して検索して" do
      # 昼食タグ(id:2)
      before do
        select("昼食", from: "q[meal_tag_id_eq]")
        click_button '検索'
      end

      it '正しく結果が表示される' do
        expect(page).not_to have_content '複数条件絞り込み'
        expect(page).not_to have_content '2020/11/11'
        expect(page).not_to have_content 'タイトル「どこで」'
        expect(page).not_to have_content 'タイトル「誰と」'
        expect(page).not_to have_content '「詳細」指定の正解タスク'
        expect(page).not_to have_content 'タイトル指定検索テスト'
        expect(page).to have_content 'タグ検索正解タスク'
        expect(page).not_to have_content '最初の食事タスク'
        expect(page).not_to have_content '日付選択検索正解タスク'
        expect(page).not_to have_content '2021/01/20'
        click_link 'タグ検索正解タスク'
        expect(page).to have_content '「昼食」タグ正解'
      end
    end

    context "タイトルを指定して検索して" do
      # 「タイトル指定検索テスト」
      before do
        fill_in 'q[name_cont]', :with => "タイトル指定検索"
        click_button '検索'
      end

      it '正しく結果が表示される' do
        expect(page).not_to have_content '複数条件絞り込み'
        expect(page).not_to have_content '2020/11/11'
        expect(page).not_to have_content 'タイトル「どこで」'
        expect(page).not_to have_content 'タイトル「誰と」'
        expect(page).not_to have_content '「詳細」指定の正解タスク'
        expect(page).to have_content 'タイトル指定検索テスト'
        expect(page).not_to have_content 'タグ検索正解タスク'
        expect(page).not_to have_content '最初の食事タスク'
        expect(page).not_to have_content '2021/01/20'
        click_link 'タイトル指定検索テスト'
        expect(page).to have_content '「タイトル」指定検索の正解'
        expect(page).to have_content '夕食'
      end
    end

    context "詳細を指定して検索して" do
      # 「詳細指定検索用の投稿内容」
      before do
        fill_in 'q_description_cont', :with => '詳細指定'
        click_button '検索'
      end

      it '正しく結果が表示される' do
        expect(page).not_to have_content '複数条件絞り込み'
        expect(page).not_to have_content '2020/11/11'
        expect(page).not_to have_content 'タイトル「どこで」'
        expect(page).not_to have_content 'タイトル「誰と」'
        expect(page).to have_content '「詳細」指定の正解タスク'
        expect(page).not_to have_content 'タイトル指定検索テスト'
        expect(page).not_to have_content 'タグ検索正解タスク'
        expect(page).not_to have_content '最初の食事タスク'
        expect(page).not_to have_content '2021/01/20'
        click_link '「詳細」指定の正解タスク'
        expect(page).to have_content '詳細指定検索用の投稿内容'
        expect(page).to have_content '夕食'
      end
    end

    context "誰とを指定して検索して" do
      # 「ABCDさん」
      before do
        fill_in 'q_with_whom_cont', :with => "ABCDさ"
        click_button '検索'
      end

      it '正しく結果が表示される' do
        expect(page).not_to have_content '複数条件絞り込み'
        expect(page).not_to have_content '2020/11/11'
        expect(page).not_to have_content 'タイトル「どこで」'
        expect(page).to have_content 'タイトル「誰と」'
        expect(page).not_to have_content '「詳細」指定の正解タスク'
        expect(page).not_to have_content 'タイトル指定検索テスト'
        expect(page).not_to have_content 'タグ検索正解タスク'
        expect(page).not_to have_content '最初の食事タスク'
        expect(page).not_to have_content '2021/01/20'
        click_link 'タイトル「誰と」'
        expect(page).to have_content '「誰と」指定の正解'
        expect(page).to have_content 'ABCDさん'
        expect(page).to have_content '夕食'
      end
    end

    context "どこでを指定して検索して" do
      # 「どこかで」
      before do
        fill_in 'q_where_cont', :with => 'どこ'
        click_button '検索'
      end

      it '正しく結果が表示される' do
        expect(page).not_to have_content '複数条件絞り込み'
        expect(page).not_to have_content '2020/11/11'
        expect(page).to have_content 'タイトル「どこで」'
        expect(page).not_to have_content 'タイトル「誰と」'
        expect(page).not_to have_content '「詳細」指定の正解タスク'
        expect(page).not_to have_content 'タイトル指定検索テスト'
        expect(page).not_to have_content 'タグ検索正解タスク'
        expect(page).not_to have_content '最初の食事タスク'
        expect(page).not_to have_content '2021/01/20'
        click_link 'タイトル「どこで」'
        expect(page).to have_content '「どこで」指定の正解'
        expect(page).to have_content 'どこかで'
        expect(page).to have_content '夕食'
      end
    end

    context "複数の条件を指定して検索して" do
      # サプリメント(id:7),タイトル「複数条件絞り込み」,日付「2020-12-11 00:00:00」
      before do
        t1 = '2020-12-11'.to_date
        # から〜を指定
        select(t1.strftime("%Y"), from: "q[date_gteq(1i)]")
        select(t1.strftime("%-m"), from: "q[date_gteq(2i)]")
        select(t1.strftime("%-d"), from: "q[date_gteq(3i)]")
        # 〜までを指定
        select(t1.strftime("%Y"), from: "q[date_lteq_end_of_day(1i)]")
        select(t1.strftime("%-m"), from: "q[date_lteq_end_of_day(2i)]")
        select(t1.strftime("%-d"), from: "q[date_lteq_end_of_day(3i)]")

        fill_in 'q_name_cont', :with => '複数条件絞り'
        select("サプリメント", from: "q[meal_tag_id_eq]")
        click_button '検索'
      end

      it '正しく結果が表示される' do
        expect(page).to have_content '複数条件絞り込み'
        expect(page).to have_content '2020/12/11'
        expect(page).not_to have_content '2020/11/11'
        expect(page).not_to have_content 'タイトル「どこで」'
        expect(page).not_to have_content 'タイトル「誰と」'
        expect(page).not_to have_content '「詳細」指定の正解タスク'
        expect(page).not_to have_content 'タイトル指定検索テスト'
        expect(page).not_to have_content 'タグ検索正解タスク'
        expect(page).not_to have_content '最初の食事タスク'
        expect(page).not_to have_content '2021/01/20'
        click_link '複数条件絞り込み'
        expect(page).to have_content '「複数条件指定」正解のタスク'
        expect(page).to have_content '2020/12/11'
        expect(page).to have_content 'サプリメント'
        expect(page).not_to have_content '飲酒'
        expect(page).not_to have_content '2020/11/11'
      end
    end

  end


end
