module Api
  module V1
    module Admin
      class OrdersController < AdminController
        before_action :find_order, only: %i(show)
        before_action :load_order_details, only: %i(show)
        before_action :authenticate_user

        authorize_resource

        def index
          query = get_param_index
          @search = Order.ransack(query)
          @pagy, @orders = pagy @search.result.latest_order
          render json: {
            data: {
              orders: ActiveModelSerializers::SerializableResource.new(
                @orders, each_serializer: OrderSerializer
              )
            },
            message: ["Orders list fetched successfully"],
            status: 200,
            type: "Success",
            pagination: @pagy
          }
        end

        def show
          render json: {
            success: true,
            data: {
              order: ActiveModelSerializers::SerializableResource.new(
                @order, serializer: OrderDetailSerializer
              )
            },
            message: ["Order fetched successfully"]
          }
        end

        private

        def order_params
          params.require(:order).permit(:status)
        end

        def load_order_details
          @order_details = @order.order_details.includes(:book)
        end

        def find_order
          @order = Order.find_by! id: params[:id]
        end

        def get_param_index
          Hash.new.tap do |q|
            q[:status_cont] = params[:status] if params[:status].present?
            q[:name_or_id_cont] = params[:search] if params[:search].present?
          end
        end
      end
    end
  end
end
