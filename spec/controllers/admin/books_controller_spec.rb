require "rails_helper"

RSpec.describe Admin::BooksController, type: :controller do
  let!(:admin){FactoryBot.create :user, role: 0}

  let!(:book_1){FactoryBot.create :book}
  let!(:book_2){FactoryBot.create :book}
  let!(:book_3){FactoryBot.create :book}
  let!(:book_4){FactoryBot.create :book}

  before do
    sign_in admin
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
        get :edit, xhr: true, params: {id: book_1.id}
      end

      it "should render template new" do
        expect(response).to render_template :edit
      end
      it "should data book 1" do
        expect(assigns(:book)).to eq book_1
      end
    end

    context "when failure" do
      before do
        get :edit, xhr: true, params: {id: -1}
      end

      it "should flash not found" do
        expect(flash[:warning]).to eq I18n.t("admin.books.edit.not_found")
      end
      it "should redirect to root_path" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET #index" do
    it "returns a 200 response" do
      get :index
      expect(response).to have_http_status "200"
    end
  end

  describe "POST #create" do
    context "when create success" do
      let!(:book_params){FactoryBot.attributes_for :book}
      before do
        post :create, params:{book: book_params}
      end
      it "should create new book" do
        change{Book.count}.by 1
      end
      it "should flash success" do
        expect(flash[:success]).to eq I18n.t("admin.books.create.success")
      end
      it "should create new book reponse" do
        expect(response).to redirect_to admin_books_path
      end
    end
    context "when create fail" do
      before do
        post :create,params:{book: {name: ""}}
      end
      it "does not save new book" do
        change{Book.count}.by 0
      end
      it "should render new" do
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    context "when update success" do
      let(:book_params){FactoryBot.attributes_for :book}
      before do
        patch :update, params:{id: book_3.id, book: book_params}
      end
      it "should flash success" do
        expect(flash[:success]).to eq I18n.t("admin.books.update.success")
      end
    end
    context "when update fail" do
      it "should render edit" do
        patch :update, params:{id: book_3.id, book: {name: ""}}
        expect(response).to render_template :edit
      end
    end
    context "when update status book success" do
      let!(:book_status){FactoryBot.create :book, status: Book.statuses[:inactive]}
      before do
        patch :update, params:{id: book_status.id, book: {status_before_type_cast: Book.statuses[:active]}}
      end
      it "should update active" do
        expect(Book.find(book_status.id).status).to eq "active"
      end
      it "should flash success" do
        expect(flash[:success]).to eq I18n.t("admin.books.update.success")
      end
    end
  end
end
