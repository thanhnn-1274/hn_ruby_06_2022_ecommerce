class AcceptedOrderJob < ApplicationJob
  queue_as :default

  def perform order
    @order = order
    UserMailer.accepted_order(@order).deliver_later
  end
end
