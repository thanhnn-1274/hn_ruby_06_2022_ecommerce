class OrderDetailSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone_num, :address, :status,
             :user_id, :updated_at, :order_details

  def order_details
    object.order_details.map do |order_detail|
      {
        id: order_detail.id,
        price: order_detail.price,
        quantity: order_detail.quantity,
        total_money: order_detail.total_money,
        book: {
          id: order_detail.book_id,
          name: order_detail.book.name,
          price: order_detail.book.price,
          quantity: order_detail.book.quantity
        }
      }
    end
  end
end
