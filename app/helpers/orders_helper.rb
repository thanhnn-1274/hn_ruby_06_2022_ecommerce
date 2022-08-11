module OrdersHelper
  def status_order status
    hash_status = {pending: "info", accepted: "warning", canceled: "danger",
                   complete: "success", rejected: "secondary"}
    content_tag(:td, t(".#{status}"),
                class: "table-#{hash_status[status.to_sym]}")
  end

  def status_order_details status
    hash_status = {pending: "info", accepted: "warning", canceled: "danger",
                   complete: "success", rejected: "secondary"}
    content_tag(:p, t(".#{status}"),
                class: "text-#{hash_status[status.to_sym]}")
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
