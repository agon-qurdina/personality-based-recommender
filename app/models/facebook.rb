class Facebook < ApplicationRecord
  #10203046630585298?fields=context.fields(mutual_friends)
  def profile
    graph_api.get_object('me')
  end

  def graph_api
      @graph ||= Koala::Facebook::API.new(access_token, '99c84ab6d14e8826ca63b2b06ba8ab31')
  end

  def friends_count
    self[:friends_count] ||= graph_api.get_connections('me', 'friends').raw_response['summary']['total_count']
  end

  def taggable_friends
    graph_api.get_connections('me', 'taggable_friends').raw_response
  end

  def posts_with_message(limit = 200)
    @posts_with_message ||= begin

      posts_with_message = []

      response = graph_api.get_connections('me', 'posts', { fields: 'message' })

      loop do
        posts_with_message += response.to_a.select { |i| i['message'] }.each do |post|
          post['words_count'] = post['message'].to_s.split(/[\p{Alpha}\-']+/).count
          post['hashtags_count'] = post['message'].to_s.scan(/#([A-Za-z0-9]+)/).size
        end

        puts posts_with_message.length
        break if not (response = response.next_page) or posts_with_message.length > limit
      end

      posts_with_message
    end
  end

  # Obtain yours from https://developers.facebook.com/tools/explorer?method=GET&path=me&version=v2.8
  # def access_token
  #   @access_token ||= 'EAACEdEose0cBAIgghRBkZAtPyvPOXr2RLIfIzjGzBm6mvAVAIdxVlUEKxVllTa6AZACsLNzyrMAZCaReRKGPjiorm8ObmOSSpmzD34vxZBAMZCuKQi5zkiETME98bUpWqO2et7DWYU4JEnanBIrpiKQ14vNbFpCW4GUsZBH524ygZDZD'
  # end

  def translate_statuses(statuses)
    if statuses.count == 0
      return
    end
    google_token = 'ya29.El_OA6qOljjavTGd9Wy1yLt1xx6q6W1723rsfbslRz8orxK6o6H_U_N6k3Fgp2Mc5WuJakspxpt6PCUSQdJ9gtK7cUwVbg_IWrQujN4VFMKfncmYjz85cUMV4WjcJKEFIQ'
    url_text = 'https://translation.googleapis.com/language/translate/v2?'
    statuses.each do |status|
        status.gsub!('#', '@@ ')
        url_text += ('q='+ status +'&')
    end
    url = URI.parse(url_text)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    headers = {
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer ' + google_token
    }
    data = {
        source: 'sq',
        target: 'en',
        format: 'text'
    }
    path = url.path + '?' + url.query
    response = JSON.parse(http.post(path, data.to_json, headers).body)
    statuses = []
    response['data']['translations'].each do |translation|
      translation['translatedText'].gsub!('@@ ', '#')
      statuses.push translation['translatedText']
    end
    statuses
  end

  def posts_with_sentiment
    @posts_with_sentiment ||= begin
      apiKey = "25a09e5c2a37450f8598d10c70757e72"

      url = URI.parse("https://westus.api.cognitive.microsoft.com/text/analytics/v2.0/sentiment")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true


      headers = {
          'Content-Type' => 'application/json',
          'Ocp-Apim-Subscription-Key' => apiKey
      }

      posts = {}
      posts_with_message.each { |i| posts[i['id']] = i }

      documents = posts.values.map { |i| { language: 'en', id: i['id'], text: i['message'] } }

      texts = posts.values.map { |i| i['message'] }
      texts = translate_statuses texts
      documents.each_with_index { |doc, i| doc['text'] = texts[i] }

      data = {
          documents: documents
      }

      response = JSON.parse(http.post(url.path, data.to_json, headers).body)

      response['documents'].each do |document|
        posts[document['id']]['sentiment'] = document['score']
      end

      posts
    end
  end

  def avg_posts_sentiment
    self[:avg_posts_sentiment] ||= begin
      sum = 0

      posts = posts_with_sentiment.values

      posts.each do |post|
        sum += post['sentiment']
      end

      sum / posts.length.to_f
    end
  end

  def words_per_post
    self[:words_per_post] ||= begin
      sum = 0

      posts_with_message.each do |post|
        sum += post['words_count']
      end

      sum / posts_with_message.length.to_f
    end
  end

  def hashtags_per_post
    self[:hashtags_per_post] ||= begin
      sum = 0

      posts_with_message.each do |post|
        sum += post['hashtags_count']
      end

      sum / posts_with_message.length.to_f
    end
  end

  def personal_info
    @personal_info ||= begin
      personal_info = {}

      response = graph_api.get_object(:me, { fields: [
          :first_name,
          :last_name,
          :birthday,
          :gender,
          :about,
          :inspirational_people,
          :interested_in,
          :religion,
          :relationship_status,
          :books,
          :favorite_athletes,
          :favorite_teams
      ] })

      personal_info[:fb_id] = response['id']
      personal_info[:last_name_length] = response['last_name'].nil? ? 0 : response['last_name'].length
      personal_info[:relationship_status] = !response[:relationship_status].nil?
      personal_info[:activities_length] = response['interested_in'].nil? ? 0 : response['interested_in'].length
      personal_info[:favorites_count] = (response['favorite_athletes'].nil? ? 0 : response['favorite_athletes'].count) + (response['favorite_teams'].nil? ? 0 : response['favorite_teams'].count) + (response['books'].nil? ? 0 : response['books'].count)

      personal_info
    end
  end

  def last_name_length
    self[:last_name_length] ||= personal_info[:last_name_length]
  end

  def relationship_status
    self[:relationship_status] ||= personal_info[:relationship_status]
  end

  def activities_length
      self[:activities_length] ||= personal_info[:activities_length]
  end

  def favorites_count
    self[:favorites_count] ||= personal_info[:favorites_count]
  end

  def fb_id
    self[:fb_id] ||= personal_info[:fb_id]
  end

end
