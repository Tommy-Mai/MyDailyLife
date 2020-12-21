require 'rails_helper'

describe "その他タグ管理機能", :type => :system do
  # ユーザーをletで定義
  let(:user_a) { FactoryBot.find_or_create(:user, :name => 'ユーザーA', :email => 'a@example.com', :password => 'password', :admin => true) }
  let(:user_b) { FactoryBot.find_or_create(:user, :name => 'ユーザーB', :email => 'b@example.com', :password => 'password', :admin => false) }

  before do
    # その他タグの作成
    FactoryBot.create(:task_tag, :id => 1, :name => "映画", :user_id => user_a.id)
    FactoryBot.create(:task_tag, :id => 2, :name => "ドラマ", :user_id => user_b.id)
  end

  # 作成者がユーザーAであるその他タスクを作成する
  let!(:task_a) { FactoryBot.create(:task, :id => 1, :name => '最初のその他タスク', :description => 'その他タスクテスト投稿', :user => user_a, :task_tag_id => 1, :date => Time.zone.now) }

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
        expect(page).to have_content '映画'
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
        expect(page).to have_content 'ドラマ'
        expect(page).not_to have_content '映画'
      end
    end

  end

  describe "ユーザーAがログインしているとき、その他タグ一覧ページで" do
    let(:login_user) { user_a }
    before do
      visit task_tags_path
    end

    describe "タグ削除ボタンを押して" do
      it '確認画面で削除に同意を選ぶと「映画」タグが削除される' do
        find(:css, 'i.fas.fa-trash-alt').click
        expect{
          wait = Selenium::WebDriver::Wait.new ignore: Selenium::WebDriver::Error::NoAlertPresentError
          wait.until { page.accept_confirm }
          within '.flash' do
            expect(page).to have_content 'タグ「映画」を削除しました。'
          end
        }.to change(user_a.task_tags, :count).by(-1)
        visit task_tags_path
        expect(page).not_to have_content '映画'
      end
    end

    describe "その他タグ新規作成ボタンを押して" do
      context "正しく入力したとき" do
        before do
          find(:css, 'i.fas.fa-plus').click
          expect(page).to have_content '新規タグを作成する'
          fill_in name="task_tag[name]", :with => "新規タグ作成テスト"
          click_button '登録する'
        end

        it '新規タグ作成成功のflashが表示される' do
          within '.flash' do
            expect(page).to have_content "新規タグ「新規タグ作成テスト」を登録しました。"
          end
        end
      end

      context "正しく入力しなかったとき" do
        before do
          find(:css, 'i.fas.fa-plus').click
          expect(page).to have_content '新規タグを作成する'
          fill_in name="task_tag[name]", :with => ""
          click_button '登録する'
        end

        it 'エラー文が表示される' do
          expect(page.accept_confirm).to eq "エラー：タグを登録できませんでした。\n・空白のタグは登録できません。\n・同じ名前のタグは登録できません。\n・31文字以上のタグは登録できません。"
        end
      end
    end

    describe "その他タグ編集テスト" do

      context "正しく入力しなかったとき(同じ名前)" do
        before do
          find(:css, 'i.fas.fa-edit').click
          expect(page).to have_content '映画'
          fill_in name="task_tag[name]", :with => ""
          click_button '更新する'
        end

        it 'エラー文が表示される' do
          expect(page.accept_confirm).to eq "エラー：タグを更新できませんでした。\n・空白のタグは登録できません。\n・同じ名前のタグは登録できません。\n・31文字以上のタグは登録できません。"
        end
      end
      
      context "正しく入力したとき" do
        before do
          find(:css, 'i.fas.fa-edit').click
          expect(page).to have_content 'タグを編集する'
          expect(page).to have_field(with: "映画")
          fill_in name="task_tag[name]", :with => "タグ編集テスト"
          click_button '更新する'
        end

        it 'タグ編集成功のflashが表示される' do
          within '.flash' do
            expect(page).to have_content "タグ「タグ編集テスト」に更新しました。"
          end
        end
      end

      context "正しく入力しなかったとき(空白)" do
        before do
          find(:css, 'i.fas.fa-edit').click
          expect(page).to have_content 'タグを編集する'
          fill_in name="task_tag[name]", :with => ""
          click_button '更新する'
        end
        
        it 'エラー文が表示される' do
          expect(page.accept_confirm).to eq "エラー：タグを更新できませんでした。\n・空白のタグは登録できません。\n・同じ名前のタグは登録できません。\n・31文字以上のタグは登録できません。"
        end
      end
    end

    describe "その他タグ検索機能テスト" do
      before do
          # 検証用タグを作成(名前が一意である必要があるためcreate_list不使用)
        FactoryBot.create(:task_tag, id: 3, name: '検索用ダミータグ', user: user_a)
        FactoryBot.create(:task_tag, id: 4, name: '検索用ダミータグ01', user: user_a)
        FactoryBot.create(:task_tag, id: 5, name: '検索用ダミータグ02', user: user_a)
        FactoryBot.create(:task_tag, id: 6, name: '検索用ダミータグ03', user: user_a)
        FactoryBot.create(:task_tag, id: 7, name: '検索用ダミータグ04', user: user_a)
        FactoryBot.create(:task_tag, id: 8, name: '検索用ダミータグ05', user: user_a)
        FactoryBot.create(:task_tag, id: 9, name: '検索用ダミータグ06', user: user_a)
        FactoryBot.create(:task_tag, id: 10, name: '検索用ダミータグ07', user: user_a)
        FactoryBot.create(:task_tag, id: 11, name: '検索用ダミータグ08', user: user_a)
        FactoryBot.create(:task_tag, id: 12, name: '検索用ダミータグ09', user: user_a)
        FactoryBot.create(:task_tag, id: 13, name: '検索用ダミータグ10', user: user_a)
        FactoryBot.create(:task_tag, id: 14, name: '検索用ダミータグ11', user: user_a)
        FactoryBot.create(:task_tag, id: 15, name: '検索用ダミータグ12', user: user_a)
        FactoryBot.create(:task_tag, id: 16, name: '検索用ダミータグ13', user: user_a)
        FactoryBot.create(:task_tag, id: 17, name: '検索用ダミータグ14', user: user_a)
        FactoryBot.create(:task_tag, id: 18, name: '検索用ダミータグ15', user: user_a)
        FactoryBot.create(:task_tag, id: 19, name: '検索用ダミータグ16', user: user_a)
        FactoryBot.create(:task_tag, id: 20, name: '検索用ダミータグ17', user: user_a)
        FactoryBot.create(:task_tag, id: 21, name: '検索用ダミータグ18', user: user_a)
        FactoryBot.create(:task_tag, id: 22, name: '検索用ダミータグ19', user: user_a)
        FactoryBot.create(:task_tag, id: 23, name: '検索用ダミータグ20', user: user_a)

        visit task_tags_path
        find(:css, 'i.fas.fa-search-plus').click
      end

      context "部分一致で検索" do
        before do
          fill_in name="q[name_cont]", :with => "タグ0"
          click_button '検索'
        end

        it '想定どおりの結果が表示される' do
          expect(first('.task-name')).not_to eq '検索用ダミータグ'
          expect(page).to have_content '検索用ダミータグ01'
          expect(page).to have_content '検索用ダミータグ02'
          expect(page).to have_content '検索用ダミータグ03'
          expect(page).to have_content '検索用ダミータグ04'
          expect(page).to have_content '検索用ダミータグ05'
          find(:css, '.next').click
          expect(page).to have_content '検索用ダミータグ06'
          expect(page).to have_content '検索用ダミータグ07'
          expect(page).to have_content '検索用ダミータグ08'
          expect(page).to have_content '検索用ダミータグ09'
          expect(page).not_to have_content '検索用ダミータグ10'
          expect(page).not_to have_content '検索用ダミータグ11'
          expect(page).not_to have_content '検索用ダミータグ12'
          expect(page).not_to have_content '検索用ダミータグ13'
          expect(page).not_to have_content '検索用ダミータグ14'
          expect(page).not_to have_content '検索用ダミータグ15'
          expect(page).not_to have_content '検索用ダミータグ16'
          expect(page).not_to have_content '検索用ダミータグ17'
          expect(page).not_to have_content '検索用ダミータグ18'
          expect(page).not_to have_content '検索用ダミータグ19'
          expect(page).not_to have_content '検索用ダミータグ20'
        end
      end

      context "完全一致で検索" do
        before do
          fill_in name="q[name_eq]", :with => "検索用ダミータグ"
          click_button '検索'
        end

        it '想定どおりの結果が表示される' do
          expect(page).to have_content '検索用ダミータグ'
          expect(page).not_to have_content '検索用ダミータグ01'
          expect(page).not_to have_content '検索用ダミータグ02'
          expect(page).not_to have_content '検索用ダミータグ03'
          expect(page).not_to have_content '検索用ダミータグ04'
          expect(page).not_to have_content '検索用ダミータグ05'
          expect(page).not_to have_content '検索用ダミータグ06'
          expect(page).not_to have_content '検索用ダミータグ07'
          expect(page).not_to have_content '検索用ダミータグ08'
          expect(page).not_to have_content '検索用ダミータグ09'
          expect(page).not_to have_content '検索用ダミータグ10'
          expect(page).not_to have_content '検索用ダミータグ11'
          expect(page).not_to have_content '検索用ダミータグ12'
          expect(page).not_to have_content '検索用ダミータグ13'
          expect(page).not_to have_content '検索用ダミータグ14'
          expect(page).not_to have_content '検索用ダミータグ15'
          expect(page).not_to have_content '検索用ダミータグ16'
          expect(page).not_to have_content '検索用ダミータグ17'
          expect(page).not_to have_content '検索用ダミータグ18'
          expect(page).not_to have_content '検索用ダミータグ19'
          expect(page).not_to have_content '検索用ダミータグ20'
        end
      end
    end

    describe "タスク作成ボタンを押して" do
      before do
        first(:css, 'i.fas.fa-pencil-alt').click
      end

      it '選んだタグの新規タスク作成ページが表示される' do
        expect(page).to have_content 'タスクを作成する'
        expect(page).to have_select('task[task_tag_id]', selected: '映画')
      end
    end

  end

end

