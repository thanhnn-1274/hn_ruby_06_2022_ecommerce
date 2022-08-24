class OrderSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone_num, :address, :status,
             :user_id, :updated_at
end
