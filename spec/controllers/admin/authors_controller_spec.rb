require "rails_helper"

RSpec.describe Admin::AuthorsController, type: :controller do
  let!(:admin){FactoryBot.create :user, role: 0}

  let!(:author_1){FactoryBot.create :author}
  let!(:author_2){FactoryBot.create :author}
  let!(:author_3){FactoryBot.create :author}
  let!(:author_4){FactoryBot.create :author}

  before do
    sign_in admin
  end

  describe "POST #create" do
    context "when create success" do
      let!(:author_params){FactoryBot.attributes_for :author}
      before do
        post :create, params:{author: author_params}
      end
      it "should create new author" do
        change{Author.count}.by 1
      end
      it "should flash success" do
        expect(flash[:success]).to eq I18n.t("admin.authors.success")
      end
      it "should create new author reponse" do
        expect(response).to redirect_to new_admin_book_path
      end
    end
    context "when create fail" do
      before do
        post :create, params:{author: {name: ""}}
      end
      it "does not save new author" do
        change{Author.count}.by 0
      end
      it "should author reponse" do
        expect(response).to redirect_to new_admin_book_path
      end
    end
  end
end
