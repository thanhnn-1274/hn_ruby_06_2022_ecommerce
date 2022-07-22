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
end
