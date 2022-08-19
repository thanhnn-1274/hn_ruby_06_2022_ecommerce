require "rails_helper"

RSpec.describe Admin::CategoriesController, type: :controller do
  let!(:admin){FactoryBot.create :user, role: 0}

  let!(:category_1){FactoryBot.create :category}
  let!(:category_2){FactoryBot.create :category}
  let!(:category_3){FactoryBot.create :category}
  let!(:category_4){FactoryBot.create :category}

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "returns a 200 response" do
      get :index
      expect(response).to have_http_status "200"
    end
  end

  describe "GET #new" do
    it "should render template new" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    context "when success" do
      before do
        get :edit, xhr: true, params: {id: category_1.id}
      end

      it "should render template new" do
        expect(response).to render_template :edit
      end
      it "should data category 1" do
        expect(assigns(:category)).to eq category_1
      end
    end

    context "when failure" do
      before do
        get :edit, xhr: true, params: {id: -1}
      end

      it "should flash not found" do
        expect(flash[:warning]).to eq "Không tìm danh mục"
      end
      it "should redirect to root_path" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "PATCH #update" do
    context "when update category success" do
      before do
        patch :update, xhr: true, params: {id: category_1.id, category: {name: "haha"}}
      end
      it "should change category name" do
        expect(Category.find(category_1.id).name).to eq "haha"
      end
      it "should flash success" do
        expect(flash[:success]).to eq I18n.t("admin.categories.update.success")
      end
      it "should redirect to admin_category_path" do
        expect(response).to redirect_to admin_categories_path
      end
    end
  end
end
