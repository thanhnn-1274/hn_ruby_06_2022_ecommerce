module CartsHelper
  def total_price
    products = Book.by_ids init_cart.keys
    products.reduce(0) do |total, product|
      total + product.price * @carts[product.id.to_s].to_i
    end
  end

  def total_price_book id
    if product = Book.find_by(id: id)
      init_cart[id.to_s].to_i * product.price
    else
      flash[:danger] = I18n.t ".carts.danger_book"
      redirect_to carts_path
    end
  end

  def count_carts
    init_cart.present? ? init_cart.length : 0
  end

  def clean_carts
    user_id = session[:user_id]
    session["cart_#{user_id}"].each do |key, _value|
      session["cart_#{user_id}"].delete key unless Book.find_by(id: key)
    end
  end

  def clear_carts
    user_id = session[:user_id]
    session["cart_#{user_id}"] = {}
  end

  def init_cart
    user_id = session[:user_id]
    session["cart_#{user_id}"] ||= {}
    @carts = session["cart_#{user_id}"] ||= {}
    clean_carts
  end

  def check_product_quantity
    @products.each do |item|
      product_id = item.id.to_i
      quantity = @carts[product_id.to_s]
      if item.quantity < quantity
        flash[:danger] = t(".danger_quantity", prod_id: product_id)
        redirect_to carts_path
      end
    end
  end
end
