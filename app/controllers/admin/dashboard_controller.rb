class Admin::DashboardController < ApplicationController
  def show
    @all_products = Product.count
    @all_categories = Category.count
  end
end