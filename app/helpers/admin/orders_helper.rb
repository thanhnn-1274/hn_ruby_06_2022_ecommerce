module Admin::OrdersHelper
  def status_order status
    case status
    when :pending
      content_tag(:td, t(".pending"), class: "table-info")
    when :accepted
      content_tag(:td, t(".accepted"), class: "table-warning")
    when :rejected
      content_tag(:td, t(".rejected"), class: "table-light")
    when :canceled
      content_tag(:td, t(".canceled"), class: "table-danger")
    when :complete
      content_tag(:td, t(".complete"), class: "table-success")
    end
  end
end
