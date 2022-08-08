module OrdersHelper
  def status_order status
    case status.to_sym
    when :pending
      table_class = "table-info"
    when :accepted
      table_class = "table-warning"
    when :canceled
      table_class = "table-danger"
    when :complete
      table_class = "table-success"
    end
    content_tag(:td, t(".#{status}"), class: table_class)
  end

  def status_order_details status
    case status.to_sym
    when :pending
      text_class = "text-info"
    when :accepted
      text_class = "text-warning"
    when :canceled
      text_class = "text-danger"
    when :complete
      text_class = "text-success"
    end
    content_tag(:p, t(".#{status}"), class: text_class)
  end

  def total_money_order order_details
    order_details.reduce(0) do |sum, order_detail|
      sum + order_detail.price * order_detail.quantity
    end
  end

  def status_value index
    return "" if index.zero?

    index - 1
  end
end
