require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #top" do
    it "returns http success" do
      get :top
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #about" do
    it "returns http success" do
      get :about
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #policy" do
    it "returns http success" do
      get :policy
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #privacy_policy" do
    it "returns http success" do
      get :privacy_policy
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #faqs" do
    it "returns http success" do
      get :faqs
      expect(response).to have_http_status(:success)
    end
  end
end
