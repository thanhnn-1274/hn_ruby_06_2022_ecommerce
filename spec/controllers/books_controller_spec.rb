require "rails_helper"
include CartsHelper

RSpec.describe BooksController, type: :controller do
  describe "GET #index" do
    let!(:books) {FactoryBot.create_list(:book, 10)}
    before{get :index}

    it "assigns books" do
      expect((assigns :books).count).to eq books.count
    end

    it "render the index template" do
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    let!(:book_show) {FactoryBot.create :book}

    context "when product exist" do
      before{get :show, params: {id: book_show}}

      it "returns a success response" do
        expect(response).to be_successful
      end

      it "assigns product" do
        expect(assigns :book).to eq book_show
      end
    end

    context "when product does not exit" do
      before{get :show, params: {id: 0}}

      it "redirect to books path" do
        expect(response).to redirect_to root_path
      end

      it "show flash message" do
        expect(flash[:warning]).to eq I18n.t("books.show.not_found")
      end
    end
  end
end
