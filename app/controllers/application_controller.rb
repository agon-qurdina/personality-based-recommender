class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def test

    facebook = Facebook.first

    render json: facebook.personal_info #.posts_with_message
  end
end
