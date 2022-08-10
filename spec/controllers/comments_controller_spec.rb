require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  let!(:user) {FactoryBot.create :user, role: 1}

  describe "POST #create" do
    let!(:book) {FactoryBot.create :book}
    before do
      sign_in user
    end
    
  end
end
