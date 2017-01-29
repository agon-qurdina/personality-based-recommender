class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def test
    # ActiveRecord::Base.connection.execute("TRUNCATE products RESTART IDENTITY")
    # Product.import
    render json: { test: '' }
  end
end
