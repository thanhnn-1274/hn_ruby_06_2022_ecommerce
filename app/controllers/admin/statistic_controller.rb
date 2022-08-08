class Admin::StatisticController < Admin::AdminController
  before_action :get_date, only: :index

  def index
    @order_by_day = Order.order_by_day
    @top_ten = Book.top_book
    @revenue_month = Order.revenue_month_chart
    @book_sold_by_category = Category.order_by_category
    range_day = @start_date..@end_date
    @revenue_day = Order.revenue_day_chart range_day
  end

  private

  def get_date
    @start_date = if params[:start_date].nil?
                    1.month.ago
                  else
                    params[:start_date].to_date
                  end
    @end_date = if params[:end_date].nil?
                  Time.zone.now
                else
                  params[:end_date].to_date
                end
  end
end
