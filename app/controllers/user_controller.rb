class UserController < ApplicationController
  def index
  end

  def login
  end

  def login_callback
    token = params[:token]
    session[:user_fb_token] = token
    graph_api = Koala::Facebook::API.new(token, '99c84ab6d14e8826ca63b2b06ba8ab31')
    response = graph_api.get_object(:me, { fields: [:name]})
    name = response['name'].nil? ? '' : response['name']
    session[:user_fb_name] = name
    # @fb = FbStat.new
    render json: { token: token, name: name }
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
    session[:user_fb_name] = nil
    render json: { }
  end

  def user_info
    oauth_access_token = session[:user_fb_token]
    facebook = Facebook.new
    facebook.access_token=oauth_access_token

    if Facebook.exists?({fb_id: facebook.fb_id})
      old_facebook = Facebook.where({fb_id: facebook.fb_id}).first
      facebook = old_facebook
    end
    facebook.avg_posts_sentiment
    facebook.friends_count
    facebook.hashtags_per_post
    facebook.links_per_post
    facebook.words_per_post
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
