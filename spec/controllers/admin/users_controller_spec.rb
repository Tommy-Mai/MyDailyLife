require 'rails_helper'

RSpec.describe Admin::UsersController, :type => :controller do
  let(:user_a) { FactoryBot.find_or_create(:user, :name => 'ユーザーA', :email => 'a@example.com', :password => 'password', :admin => true) }
  
  before do
    # letで定義したユーザーでログインする
    visit login_path
    fill_in 'session_email',	:with => login_user.email
    fill_in 'session_password',	:with => login_user.password
    click_button 'ログイン'
  end
  let(:login_user) { user_a }

  describe "GET #index" do
    it "returns http success" do
      subject { get :index, params }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #histories_index" do
    it "returns http success" do
      subject { get :histories_index, params }
      expect(response).to have_http_status(:success)
    end
  end
end
