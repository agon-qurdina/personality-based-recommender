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
    @graph = Koala::Facebook::API.new(oauth_access_token)
    profile = @graph.get_object(:me, { fields: [:last_name,
                                                :birthday,
                                                :gender,
                                                :about,
                                                :inspirational_people,
                                                :interested_in,
                                                :religion,
                                                :relationship_status,
                                                :books,
                                                :favorite_athletes,
                                                :favorite_teams]})
    render json: profile
  end
end
