require "rails_helper"
include CartsHelper

RSpec.describe CartsController, type: :controller do
  let!(:user) {FactoryBot.create :user, role: 1}
  let!(:product) {FactoryBot.create :book}
  let!(:product2) {FactoryBot.create :book}
  describe "when valid routing" do
    it{should route(:get, "/carts").to(action: :index)}
    it{should route(:post, "/carts").to(action: :create)}
    it{should route(:patch, "/carts/1").to(action: :update, id: 1)}
    it{should route(:delete, "/carts/1").to(action: :destroy, id: 1)}
  end

  context "When user logged in" do
    before do
      sign_in user
    end

    before { controller.stub(:authenticate_user!).and_return true }

    describe "GET #index" do
      before do
        get :index
      end

      it "renders the index template" do
        expect(response).to render_template :index
      end
    end

    describe "POST #create" do
      before do
        user_id = user.id
        session["cart_#{user_id}"] = {}
      end

      context "when product does not exist" do
        before do
          post :create, xhr: true, params: {id: 0, quantity: 5}
        end

        it "show flash message" do
          expect(flash[:danger]).to eq I18n.t("carts.create.danger_book")
        end

        it { expect(response).to redirect_to carts_path }
      end

      context "when the quantity is not true" do
        before do
          post :create, xhr: true, params: {id: product.id, quantily: 900}
        end

        it "show flash message" do
          expect(flash[:danger]).to eq I18n.t("carts.create.danger_quantily")
        end

        it { expect(response).to redirect_to book_path product.id }
      end

      context "when product already in cart" do
        before do
          @carts = session["cart_"] ||= {}
          @carts[product.id.to_s] = 2
          post :create, xhr: true, params: {id: product.id, quantily: 4}
        end

        it "add to cart succcess" do
          expect(@carts[product.id.to_s]).to eq 6
        end

        it "has a 200 status code" do
          expect(response).to have_http_status(:ok)
        end

        it "show flash message" do
          expect(flash[:success]).to eq I18n.t("carts.create.success_add")
        end
      end

      context "when product success add in cart" do
        before do
          @carts = session["cart_"] ||= {}
          post :create, xhr: true, params: {id: product.id, quantily: 4}
        end

        it "add to cart succcess" do
          expect(@carts[product.id.to_s]).to eq 4
        end

        it "has a 200 status code" do
          expect(response).to have_http_status(:ok)
        end

        it "show flash message" do
          expect(flash[:success]).to eq I18n.t("carts.create.success_add")
        end
      end
    end

    describe "PUT #update" do
      before do
        @carts = session["cart_"] ||= {}
        @carts[product.id.to_s] = 2
      end

      context "when product does not in cart" do
        before do
          put :update, xhr: true, params: {id: product2.id, quantily: 5}
        end

        it "show flash message" do
          expect(flash[:danger]).to eq I18n.t("carts.update.fail_update")
        end
      end

      context "When the quantity is not correct" do
        before do
          put :update, params: {id: product.id, quantily: 999}
        end

        it "show flash message" do
          expect(flash[:danger]).to eq I18n.t("carts.update.danger_quantily")
        end
      end

      context "when update success" do
        before do
          put :update, params: {id: product.id, quantily: 5}
        end

        it "update quantity cart succcess" do
          expect(@carts[product.id.to_s]).to eq 5
        end
      end
    end

    describe "DELETE #destroy" do
      before do
        @carts = session["cart_"] ||= {}
        @carts[product.id.to_s] = 2
      end

      context "when product does not in cart" do
        before do
          delete :destroy, xhr: true, params: {id: product2.id, quantily: 5}
        end

        it "show flash message" do
          expect(flash[:danger]).to eq I18n.t("carts.destroy.fail_delete")
        end
      end

      context "when destroy success" do
        before do
          delete :destroy, params: {id: product.id, quantily: 5}
        end

        it "delete item cart succcess" do
          expect(@carts[product.id.to_s].nil?).to eq true
        end
      end
    end
  end
end
