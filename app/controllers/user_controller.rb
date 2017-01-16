class UserController < ApplicationController
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

  def calculate
    openness = []
    conscientiousness = []
    extraversion = []
    agreeableness = []
    neuroticism = []
    personality = Personality.new

    facebook = Facebook.first!

    avg_post_sentiment = facebook.avg_posts_sentiment.to_f
    openness.push(personality.coefficients[:user_sentiment][:openness]*avg_post_sentiment)
    conscientiousness.push personality.coefficients[:user_sentiment][:conscientiousness]*avg_post_sentiment
    extraversion.push personality.coefficients[:user_sentiment][:extraversion]*avg_post_sentiment
    agreeableness.push personality.coefficients[:user_sentiment][:agreeableness]*avg_post_sentiment
    neuroticism.push personality.coefficients[:user_sentiment][:neuroticism]*avg_post_sentiment

    hashtags_per_post = facebook.hashtags_per_post.to_f
    openness.push(personality.coefficients[:number_of_hashtags][:openness]*hashtags_per_post)
    conscientiousness.push personality.coefficients[:number_of_hashtags][:conscientiousness]*hashtags_per_post
    extraversion.push personality.coefficients[:number_of_hashtags][:extraversion]*hashtags_per_post
    agreeableness.push personality.coefficients[:number_of_hashtags][:agreeableness]*hashtags_per_post
    neuroticism.push personality.coefficients[:number_of_hashtags][:neuroticism]*hashtags_per_post

    words_per_post = facebook.words_per_post.to_f
    openness.push personality.coefficients[:words_per_status][:openness]*words_per_post
    conscientiousness.push personality.coefficients[:words_per_status][:conscientiousness]*words_per_post
    extraversion.push personality.coefficients[:words_per_status][:extraversion]*words_per_post
    agreeableness.push personality.coefficients[:words_per_status][:agreeableness]*words_per_post
    neuroticism.push personality.coefficients[:words_per_status][:neuroticism]*words_per_post

    links_per_post = facebook.links_per_post.to_f
    openness.push personality.coefficients[:number_of_hashtags][:openness]*links_per_post
    conscientiousness.push personality.coefficients[:number_of_hashtags][:conscientiousness]*links_per_post
    extraversion.push personality.coefficients[:number_of_hashtags][:extraversion]*links_per_post
    agreeableness.push personality.coefficients[:number_of_hashtags][:agreeableness]*links_per_post
    neuroticism.push personality.coefficients[:number_of_hashtags][:neuroticism]*links_per_post

    relationship_status = facebook.relationship_status ? 1.0 : 0.0
    openness.push personality.coefficients[:relationship_status][:openness]*relationship_status
    conscientiousness.push personality.coefficients[:relationship_status][:conscientiousness]*relationship_status
    extraversion.push personality.coefficients[:relationship_status][:extraversion]*relationship_status
    agreeableness.push personality.coefficients[:relationship_status][:agreeableness]*relationship_status
    neuroticism.push personality.coefficients[:relationship_status][:neuroticism]*relationship_status

    last_name_length = facebook.last_name_length.to_f
    openness.push personality.coefficients[:last_name_length][:openness]*last_name_length
    conscientiousness.push personality.coefficients[:last_name_length][:conscientiousness]*last_name_length
    extraversion.push personality.coefficients[:last_name_length][:extraversion]*last_name_length
    agreeableness.push personality.coefficients[:last_name_length][:agreeableness]*last_name_length
    neuroticism.push personality.coefficients[:last_name_length][:neuroticism]*last_name_length

    activities_length = facebook.activities_length.to_f
    openness.push personality.coefficients[:activities_length][:openness]*activities_length
    conscientiousness.push personality.coefficients[:activities_length][:conscientiousness]*activities_length
    extraversion.push personality.coefficients[:activities_length][:extraversion]*activities_length
    agreeableness.push personality.coefficients[:activities_length][:agreeableness]*activities_length
    neuroticism.push personality.coefficients[:activities_length][:neuroticism]*activities_length

    favorites_count = facebook.favorites_count.to_f
    openness.push personality.coefficients[:favorites_count][:openness]*favorites_count
    conscientiousness.push personality.coefficients[:favorites_count][:conscientiousness]*favorites_count
    extraversion.push personality.coefficients[:favorites_count][:extraversion]*favorites_count
    agreeableness.push personality.coefficients[:favorites_count][:agreeableness]*favorites_count
    neuroticism.push personality.coefficients[:favorites_count][:neuroticism]*favorites_count

    friends_count = facebook.friends_count.to_f
    openness.push personality.coefficients[:number_of_friends][:openness]*friends_count
    conscientiousness.push personality.coefficients[:number_of_friends][:conscientiousness]*friends_count
    extraversion.push personality.coefficients[:number_of_friends][:extraversion]*friends_count
    agreeableness.push personality.coefficients[:number_of_friends][:agreeableness]*friends_count
    neuroticism.push personality.coefficients[:number_of_friends][:neuroticism]*friends_count

    openness_avg = 0.0
    openness.each { |o| openness_avg += o.to_f }
    openness_avg = openness_avg / openness.size.to_f
    personality.openness=openness_avg

    conscientiousness_avg = 0.0
    conscientiousness.each { |o| conscientiousness_avg += o.to_f }
    conscientiousness_avg = conscientiousness_avg / conscientiousness.size.to_f
    personality.conscientiousness=conscientiousness_avg

    extraversion_avg = 0.0
    extraversion.each { |o| extraversion_avg += o.to_f }
    extraversion_avg = extraversion_avg / extraversion.size.to_f
    personality.extraversion=extraversion_avg

    agreeableness_avg = 0.0
    agreeableness.each { |o| agreeableness_avg += o.to_f }
    agreeableness_avg = agreeableness_avg / agreeableness.size.to_f
    personality.agreeableness=agreeableness_avg

    neuroticism_avg = 0.0
    neuroticism.each { |o| neuroticism_avg += o.to_f }
    neuroticism_avg = neuroticism_avg / neuroticism.size.to_f
    personality.neuroticism=neuroticism_avg

    personality.save!

    render json: {personality: personality, openness: openness, conscientiousness: conscientiousness, extraversion: extraversion, agreeableness: agreeableness, neuroticism: neuroticism}
  end
end
