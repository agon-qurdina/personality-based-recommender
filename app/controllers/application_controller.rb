class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def test
    extremes = Facebook.get_extremes

    render json: extremes
  end
end
