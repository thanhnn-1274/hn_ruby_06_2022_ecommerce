require "rails_helper"

RSpec.describe Admin::OrdersController, type: :controller do
  let!(:admin){FactoryBot.create :user, role: 0}
  let!(:user_1){FactoryBot.create :user}

  let!(:book_1){FactoryBot.create :book}
  let!(:book_2){FactoryBot.create :book}
  let!(:book_3){FactoryBot.create :book}

  let!(:order){FactoryBot.create :order, user_id: user_1.id, name: "AAA", status: 3}
  let!(:order_1){FactoryBot.create :order, user_id: user_1.id, name: "CCC", status: 0}
  let!(:order_2){FactoryBot.create :order, user_id: user_1.id, name: "BBB", status: 1}
  let!(:order_3){FactoryBot.create :order, user_id: user_1.id, name: "DDD", status: 2}
  let!(:order_details_1){FactoryBot.create :order_detail, book_id: book_1.id, order_id: order.id}

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "returns a 200 response"	do
      get :index
      expect(response).to have_http_status "200"
    end

    it "redirect to root" do
      sign_out admin
      get :index
      expect(response).to redirect_to root_path
    end

    it "should return all orders" do
      get :index
      expect(assigns(:orders).count).to eq 4
    end

    context "initialized with select all and input QQQ" do
      it "should not found order" do
        get :index, params: {q: {name_or_id_cont: "QQQ", status_cont: ""}}
        expect(assigns(:orders).pluck(:id)).to eq []
      end
    end

    context "initialized with select pending[0] and input empty" do
      it "should found order" do
        get :index, params: {q: {name_or_id_cont: "", status_cont: "0"}}
        expect(assigns(:orders).pluck(:id)).to eq [order_1.id]
      end
    end

    context "initialized with select pending[0] and input C" do
      it "should found order" do
        get :index, params: {q: {name_or_id_cont: "C", status_cont: "0"}}
        expect(assigns(:orders).pluck(:id)).to eq [order_1.id]
      end
    end

    context "initialized with select accepted[1] and input empty" do
      it "should found order" do
        get :index, params: {q: {name_or_id_cont: "", status_cont: "1"}}
        expect(assigns(:orders).pluck(:id)).to eq [order_2.id]
      end
    end

    context "initialized with select accepted[2] and input empty" do
      it "should found order" do
        get :index, params: {q: {name_or_id_cont: "", status_cont: "2"}}
        expect(assigns(:orders).pluck(:id)).to eq [order_3.id]
      end
    end

    context "initialized with select canceled[3] and input empty" do
      it "should found order" do
        get :index, params: {q: {name_or_id_cont: "", status_cont: "3"}}
        expect(assigns(:orders).pluck(:id)).to eq [order.id]
      end
    end
  end
end
