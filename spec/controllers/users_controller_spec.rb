require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  let(:user_a) { FactoryBot.find_or_create(:user, :name => 'ユーザーA', :email => 'a@example.com', :password => 'password', :admin => true) }

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "ユーザーAがログインしているとき" do
    before do
      # letで定義したユーザーでログインする
      visit login_path
      fill_in 'session_email',	:with => login_user.email
      fill_in 'session_password',	:with => login_user.password
      click_button 'ログイン'
    end
    let(:login_user) { user_a }

    context "GET #edit" do 
      it "returns http success" do
        subject { get :edit, params }
        expect(response).to have_http_status(:success)
      end
    end

    context "GET #show" do
      it "returns http success" do
        subject { get :show, params }
        expect(response).to have_http_status(:success)
      end
    end

    context "GET #other_tasks" do
      it "returns http success" do
        subject { get :other_tasks, params }
        expect(response).to have_http_status(:success)
      end
    end

    context "GET #memos" do
      it "returns http success" do
        subject { get :memos, params }
        expect(response).to have_http_status(:success)
      end
    end
  end
end
