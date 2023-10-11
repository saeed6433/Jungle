class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :cart, :enhanced_cart, :cart_subtotal_cents

  before_action :set_current_user

  def authorize
    redirect_to login_path unless current_user
  end

  private
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end 

  def set_current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def cart
    @cart ||= cookies[:cart].present? ? JSON.parse(cookies[:cart]) : {}
  end

  def enhanced_cart
    @enhanced_cart ||= Product.where(id: cart.keys).map do |product|
      { product: product, quantity: cart[product.id.to_s] }
    end
  end

  def cart_subtotal_cents
    @cart_subtotal_cents ||= enhanced_cart.sum { |entry| entry[:product].price_cents * entry[:quantity] }
  end

  def update_cart(new_cart)
    cookies[:cart] = {
      value: JSON.generate(new_cart),
      expires: 10.days.from_now
    }
  end
end
