class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def test

    facebook = Facebook.new


    render json: facebook.avg_posts_sentiment

  end
end
