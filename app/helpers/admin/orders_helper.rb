module Admin::OrdersHelper
  def status_order status
    case status
    when :pending
      content_tag(:td, t(".pending"), class: "table-info")
    when :accepted
      content_tag(:td, t(".accepted"), class: "table-warning")
    when :canceled
      content_tag(:td, t(".canceled"), class: "table-danger")
    when :complete
      content_tag(:td, t(".complete"), class: "table-success")
    end
  end

  def select_status status
    case status
    when :pending
      Order.statuses.select{|k, _v| %w(accepted canceled).include?(k)}
    when :accepted
      Order.statuses.select{|k, _v| %w(canceled complete).include?(k)}
    end
  end

  def total_money_order order_details
    order_details.reduce(0) do |sum, order_detail|
      sum + order_detail.price * order_detail.quantity
    end
  end
end
