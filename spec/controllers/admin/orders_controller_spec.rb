require "rails_helper"
include Admin::OrdersHelper

RSpec.describe Admin::OrdersController, type: :controller do
  before do
    allow_any_instance_of(Order).to receive(:send_mail_notification).and_return(true)
  end

  let!(:admin){FactoryBot.create :user, role: 0}
  let!(:user_1){FactoryBot.create :user}

  let!(:book){FactoryBot.create :book}
  let!(:book){FactoryBot.create :book, quantity: 6}
  let!(:book_1){FactoryBot.create :book, quantity: 7}
  let!(:book_2){FactoryBot.create :book, quantity: 8}
  let!(:book_3){FactoryBot.create :book, quantity: 9}
  let!(:book_4){FactoryBot.create :book, quantity: 10}

  let(:order){FactoryBot.create :order, user_id: user_1.id, name: "AAA", status: :canceled}
  let(:order_1){FactoryBot.create :order, user_id: user_1.id, name: "CCC", status: :pending}
  let(:order_2){FactoryBot.create :order, user_id: user_1.id, name: "BBB", status: :accepted}
  let(:order_3){FactoryBot.create :order, user_id: user_1.id, name: "DDD", status: :complete}
  let(:order_4){FactoryBot.create :order, user_id: user_1.id, name: "EEE", status: :rejected}

  let!(:order_details){FactoryBot.create :order_detail, quantity: 4, book_id: book.id, order_id: order.id}
  let!(:order_details_1){FactoryBot.create :order_detail, quantity: 4, book_id: book_1.id, order_id: order_1.id}
  let!(:order_details_2){FactoryBot.create :order_detail, quantity: 4, book_id: book_2.id, order_id: order_2.id}
  let!(:order_details_3){FactoryBot.create :order_detail, quantity: 50, book_id: book_3.id, order_id: order_3.id}
  let!(:order_details_4){FactoryBot.create :order_detail, quantity: 5, book_id: book_4.id, order_id: order_4.id}

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
      expect(assigns(:orders).count).to eq 5
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
    context "initialized with select canceled[4] and input empty" do
      it "should found order" do
        get :index, params: {q: {name_or_id_cont: "", status_cont: "4"}}
        expect(assigns(:orders).pluck(:id)).to eq [order_4.id]
      end
    end
  end

  describe "GET #show" do
    context "when find order details" do
      it "should respond to 200" do
        get :show, xhr: true, params:{id: order.id}
        expect(response.status).to eq 200
      end
      it "should one order details" do
        get :show, xhr: true, params:{id: order.id}
        expect(assigns(:order_details).count).to eq 1
      end
    end
    context "when not order" do
      it "should redirect to admin_orders_path" do
        get :show, xhr: true, params:{id: -1}
        expect(response).to redirect_to admin_root_path
      end
      it "should flash warning not found" do
        get :show, xhr: true, params:{id: -1}
        expect(flash[:warning]).to eq I18n.t("admin.orders.show.not_found")
      end
    end
  end

  describe "PATCH #update" do
    # before do
    #   allow_any_instance_of(Order).to receive(:send_mail_notification).and_return(true)
    # end

    context "when update order success with status accepted" do
      before do
        patch :update, xhr: true, params: {id: order_1.id, order:{status: Order.statuses[:accepted]}}
      end
      it "should update quantity unaltered" do
        expect(Book.find(book_1.id).quantity).to eq 7
      end
      it "should flash success" do
        expect(flash[:success]).to eq I18n.t("admin.orders.update.success")
      end
      it "should redirect to admin_order_path" do
        expect(response).to redirect_to admin_orders_path
      end
    end
    context "when update order success with status complete" do
      before do
        patch :update, params: {id: order_2.id, order:{status: Order.statuses[:complete]}}
      end
      it "should update quantity reduced" do
        expect(Book.find(book_2.id).quantity).to eq 4
      end
      it "should flash success" do
        expect(flash[:success]).to eq I18n.t("admin.orders.update.success")
      end
      it "should redirect to admin_order_path" do
        expect(response).to redirect_to admin_orders_path
      end
    end
    context "when update order failure with status complete when quantity < 0" do
      let!(:order_test){FactoryBot.create :order, user_id: user_1.id, name: "EEE", status: :accepted}
      let!(:book_test){FactoryBot.create :book, quantity: 10}
      let!(:order_details_test){FactoryBot.create :order_detail, quantity: 11,
                                book_id: book_test.id, order_id: order_test.id}

      before do
        patch :update, params: {id: order_test.id, order:{status: Order.statuses[:complete]}}
      end
      it "should update quantity unaltered" do
        expect(Book.find(book_test.id).quantity).to eq 10
      end
      it "should flash danger" do
        expect(flash[:danger]).to eq split_content_error assigns(:order).errors[:base]
      end
      it "should redirect to admin_order_path" do
        expect(response).to redirect_to admin_orders_path
      end
    end
    # admin chấp nhận đơn hàng nhưng user đã hủy
    context "when update order fault with status invalid" do
      before do
        patch :update, xhr: true, params: {id: order.id, order:{status: Order.statuses[:complete]}}
      end
      it "should flash danger" do
        expect(flash[:danger]).to eq I18n.t("admin.orders.update.danger")
      end
      it "should redirect to admin_order_path" do
        expect(response).to redirect_to admin_orders_path
      end
    end
  end
end
