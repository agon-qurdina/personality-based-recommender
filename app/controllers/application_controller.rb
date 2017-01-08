class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def test

    facebook = Facebook.new


    render json: facebook.friends_count

  end
end
