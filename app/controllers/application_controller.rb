class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def test
    products = Product.where('id IN (?)',[4877,695]).to_a
    render json: { count: products}
  end
end
