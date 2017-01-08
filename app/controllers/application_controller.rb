class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def test

    facebook = Facebook.first

    p facebook.avg_posts_sentiment
    p facebook.avg_posts_sentiment
    p facebook.avg_posts_sentiment
    p facebook.friends_count

    facebook.save

    render json: facebook

  end
end
