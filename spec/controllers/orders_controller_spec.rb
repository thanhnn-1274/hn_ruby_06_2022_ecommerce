require "rails_helper"

RSpec.describe OrdersController, type: :controller do
  let!(:user) {FactoryBot.create :user, role: 1}

  context "When user logged in" do
    before do
      sign_in user
    end

    describe "GET #new" do
      before do
        get :new
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end
    end
  end
end
