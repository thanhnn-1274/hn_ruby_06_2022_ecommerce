require "rails_helper"

RSpec.describe Admin::UsersController, type: :controller do
  let!(:admin){FactoryBot.create :user, role: 0}

  let!(:user_1){FactoryBot.create :user}
  let!(:user_2){FactoryBot.create :user, locked_at: Time.now}
  let!(:user_3){FactoryBot.create :user}
  let!(:user_4){FactoryBot.create :user}

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "returns a 200 response" do
      get :index
      expect(response).to have_http_status "200"
    end
  end
  describe "PATCH #ban" do
    it "user is looked" do
      patch :ban, xhr: true, params: {id: user_1.id}
      expect(assigns(:user).access_locked?).to eq true
    end
    it "user is unlooked" do
      patch :ban, xhr: true, params: {id: user_2.id}
      expect(assigns(:user).access_locked?).to eq false
    end
  end
end
