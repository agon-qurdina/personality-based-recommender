class UserController < ApplicationController
  before_action :authenticate_user!, only: [:personality, :get_fb_info, :calculate]
  def login
  end

  def personality
  end

  def test_personality
    @products = Product.with_distance_from(current_user.personality_hash).order('distance').select('id,extraversion,agreeableness,conscientiousness,neuroticism,openness,distance').limit(10).to_a

    @user = current_user.personality_hash

    render 'user/test', layout: false and return
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

  def logout_callback
    session[:user_fb_token] = nil
    session[:user_fb_name] = nil
    render json: { }
  end

  def get_fb_info
    oauth_access_token = session[:user_fb_token]
    facebook = Facebook.new
    facebook.access_token=oauth_access_token

    Facebook.destroy_all({user_id: current_user.id})

    # if Facebook.exists?({fb_id: facebook.fb_id})
    #   old_facebook = Facebook.where({fb_id: facebook.fb_id}).first
    #   facebook = old_facebook
    # end
    facebook.user_id=current_user.id
    facebook.fb_id
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

  # def user_friends
  #   oauth_access_token = session[:user_fb_token]
  #   @graph = Koala::Facebook::API.new(oauth_access_token)
  #   profile = @graph.get_object('/me/taggable_friends', { limit: 1000 })
  #   render json: profile
  # end

  def calculate
    facebook = nil

    if params[:fb_id].nil?
      facebook = Facebook.first!
    else
      facebook = Facebook.where({fb_id: params[:fb_id]}).last
    end
    openness = []
    conscientiousness = []
    extraversion = []
    agreeableness = []
    neuroticism = []
    personality = Personality.new
    personality.user_id=facebook.user_id
    personality.fb_id = facebook.fb_id

    extremes = Facebook.get_extremes

    avg_post_sentiment = facebook.avg_posts_sentiment.to_f
    openness.push (personality.coefficients[:user_sentiment][:openness]*avg_post_sentiment).round(3)
    conscientiousness.push (personality.coefficients[:user_sentiment][:conscientiousness]*avg_post_sentiment).round(3)
    extraversion.push (personality.coefficients[:user_sentiment][:extraversion]*avg_post_sentiment).round(3)
    agreeableness.push (personality.coefficients[:user_sentiment][:agreeableness]*avg_post_sentiment).round(3)
    neuroticism.push (personality.coefficients[:user_sentiment][:neuroticism]*avg_post_sentiment).round(3)

    hashtags_per_post_unscaled = facebook.hashtags_per_post.to_f.round(3)
    hashtags_per_post = scale(hashtags_per_post_unscaled, extremes[:hashtags_per_post][:min], extremes[:hashtags_per_post][:max])
    openness.push (personality.coefficients[:number_of_hashtags][:openness]*hashtags_per_post).round(3)
    conscientiousness.push (personality.coefficients[:number_of_hashtags][:conscientiousness]*hashtags_per_post).round(3)
    extraversion.push (personality.coefficients[:number_of_hashtags][:extraversion]*hashtags_per_post).round(3)
    agreeableness.push (personality.coefficients[:number_of_hashtags][:agreeableness]*hashtags_per_post).round(3)
    neuroticism.push (personality.coefficients[:number_of_hashtags][:neuroticism]*hashtags_per_post).round(3)

    words_per_post_unscaled = facebook.words_per_post.to_f.round(3)
    words_per_post = scale(words_per_post_unscaled, extremes[:words_per_post][:min], extremes[:words_per_post][:max])
    openness.push (personality.coefficients[:words_per_status][:openness]*words_per_post).round(3)
    conscientiousness.push (personality.coefficients[:words_per_status][:conscientiousness]*words_per_post).round(3)
    extraversion.push (personality.coefficients[:words_per_status][:extraversion]*words_per_post).round(3)
    agreeableness.push (personality.coefficients[:words_per_status][:agreeableness]*words_per_post).round(3)
    neuroticism.push (personality.coefficients[:words_per_status][:neuroticism]*words_per_post).round(3)

    links_per_post_unscaled = facebook.links_per_post.to_f.round(3)
    links_per_post = scale(links_per_post_unscaled, extremes[:links_per_post][:min], extremes[:links_per_post][:max])
    openness.push (personality.coefficients[:number_of_hashtags][:openness]*links_per_post).round(3)
    conscientiousness.push (personality.coefficients[:number_of_hashtags][:conscientiousness]*links_per_post).round(3)
    extraversion.push (personality.coefficients[:number_of_hashtags][:extraversion]*links_per_post).round(3)
    agreeableness.push (personality.coefficients[:number_of_hashtags][:agreeableness]*links_per_post).round(3)
    neuroticism.push (personality.coefficients[:number_of_hashtags][:neuroticism]*links_per_post).round(3)

    relationship_status = facebook.relationship_status ? 1.000 : 0.000
    openness.push (personality.coefficients[:relationship_status][:openness]*relationship_status).round(3)
    conscientiousness.push (personality.coefficients[:relationship_status][:conscientiousness]*relationship_status).round(3)
    extraversion.push (personality.coefficients[:relationship_status][:extraversion]*relationship_status).round(3)
    agreeableness.push (personality.coefficients[:relationship_status][:agreeableness]*relationship_status).round(3)
    neuroticism.push (personality.coefficients[:relationship_status][:neuroticism]*relationship_status).round(3)

    last_name_length_unscaled = facebook.last_name_length.to_f.round(3)
    last_name_length = scale(last_name_length_unscaled, extremes[:last_name_length][:min], extremes[:last_name_length][:max])
    openness.push (personality.coefficients[:last_name_length][:openness]*last_name_length).round(3)
    conscientiousness.push (personality.coefficients[:last_name_length][:conscientiousness]*last_name_length).round(3)
    extraversion.push (personality.coefficients[:last_name_length][:extraversion]*last_name_length).round(3)
    agreeableness.push (personality.coefficients[:last_name_length][:agreeableness]*last_name_length).round(3)
    neuroticism.push (personality.coefficients[:last_name_length][:neuroticism]*last_name_length).round(3)

    activities_length_unscaled = facebook.activities_length.to_f.round(3)
    activities_length = scale(activities_length_unscaled, extremes[:activities_length][:min], extremes[:activities_length][:max])
    openness.push (personality.coefficients[:activities_length][:openness]*activities_length).round(3)
    conscientiousness.push (personality.coefficients[:activities_length][:conscientiousness]*activities_length).round(3)
    extraversion.push (personality.coefficients[:activities_length][:extraversion]*activities_length).round(3)
    agreeableness.push (personality.coefficients[:activities_length][:agreeableness]*activities_length).round(3)
    neuroticism.push (personality.coefficients[:activities_length][:neuroticism]*activities_length).round(3)

    favorites_count_unscaled = facebook.favorites_count.to_f.round(3)
    favorites_count = scale(favorites_count_unscaled, extremes[:favorites_count][:min], extremes[:favorites_count][:max])
    openness.push (personality.coefficients[:favorites_count][:openness]*favorites_count).round(3)
    conscientiousness.push (personality.coefficients[:favorites_count][:conscientiousness]*favorites_count).round(3)
    extraversion.push (personality.coefficients[:favorites_count][:extraversion]*favorites_count).round(3)
    agreeableness.push (personality.coefficients[:favorites_count][:agreeableness]*favorites_count).round(3)
    neuroticism.push (personality.coefficients[:favorites_count][:neuroticism]*favorites_count).round(3)

    friends_count_unscaled = facebook.friends_count.to_f.round(3)
    friends_count = scale(friends_count_unscaled, extremes[:friends_count][:min], extremes[:friends_count][:max])
    openness.push (personality.coefficients[:number_of_friends][:openness]*friends_count).round(3)
    conscientiousness.push (personality.coefficients[:number_of_friends][:conscientiousness]*friends_count).round(3)
    extraversion.push (personality.coefficients[:number_of_friends][:extraversion]*friends_count).round(3)
    agreeableness.push (personality.coefficients[:number_of_friends][:agreeableness]*friends_count).round(3)
    neuroticism.push (personality.coefficients[:number_of_friends][:neuroticism]*friends_count).round(3)

    openness_avg = 0.0
    openness.each { |o| openness_avg += o.to_f }
    openness_avg = (openness_avg / openness.size.to_f).round(3)
    personality.openness=openness_avg

    conscientiousness_avg = 0.0
    conscientiousness.each { |o| conscientiousness_avg += o.to_f }
    conscientiousness_avg = (conscientiousness_avg / conscientiousness.size.to_f).round(3)
    personality.conscientiousness=conscientiousness_avg

    extraversion_avg = 0.0
    extraversion.each { |o| extraversion_avg += o.to_f }
    extraversion_avg = (extraversion_avg / extraversion.size.to_f).round(3)
    personality.extraversion=extraversion_avg

    agreeableness_avg = 0.0
    agreeableness.each { |o| agreeableness_avg += o.to_f }
    agreeableness_avg = (agreeableness_avg / agreeableness.size.to_f).round(3)
    personality.agreeableness=agreeableness_avg

    neuroticism_avg = 0.0
    neuroticism.each { |o| neuroticism_avg += o.to_f }
    neuroticism_avg = (neuroticism_avg / neuroticism.size.to_f).round(3)
    personality.neuroticism=neuroticism_avg

    personality.save!

    render json: personality
  end

  private
  def scale(value, min_value, max_value)
    ((value - min_value)/(max_value - min_value)).to_f.round(3)
  end
end
