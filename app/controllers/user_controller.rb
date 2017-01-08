class UserController < ApplicationController
  def index
  end

  def login
  end

  def login_callback
    token = params[:token]
    session[:user_fb_token] = token
    # @fb = FbStat.new
    render json: { token: token, session: session[:user_fb_token] }
  end

  def get_token
    token = ''
    unless session[:user_fb_token].nil?
      token = session[:user_fb_token]
    end
    render json: { token: token }
  end

  def logout_callback
    session[:user_fb_token] = nil
    render json: { }
  end

  def user_info
    oauth_access_token = session[:user_fb_token]
    facebook = Facebook.new
    facebook.access_token=oauth_access_token
    facebook.avg_posts_sentiment
    facebook.friends_count
    facebook.fb_id
    facebook.last_name_length
    facebook.relationship_status
    facebook.activities_length
    facebook.favorites_count
    facebook.save!
    render json: facebook
  end

  def user_friends
    oauth_access_token = session[:user_fb_token]
    @graph = Koala::Facebook::API.new(oauth_access_token)
    profile = @graph.get_object('/me/taggable_friends', { limit: 1000 })
    render json: profile
  end
end
