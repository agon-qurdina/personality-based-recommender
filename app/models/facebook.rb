class Facebook < ApplicationRecord

  #10203046630585298?fields=context.fields(mutual_friends)
  def profile
    graph_api.get_object('me')
  end

  def graph_api
    @graph ||= Koala::Facebook::API.new(access_token)
  end

  def friends_count
    graph_api.get_connections('me', 'friends').raw_response['summary']['total_count']
  end

  def posts_with_message(limit = 200)
    return @posts_with_message if @posts_with_message

    @posts_with_message = []

    response = graph_api.get_connections('me', 'posts', { fields: 'message' })

    loop do
      @posts_with_message += response.to_a.select { |i| i['message'] }

      puts @posts_with_message.length
      break if not (response = response.next_page) or @posts_with_message.length > limit
    end

    @posts_with_message
  end

  # Obtain yours from https://developers.facebook.com/tools/explorer?method=GET&path=me&version=v2.8
  def access_token
    'EAACEdEose0cBAIgghRBkZAtPyvPOXr2RLIfIzjGzBm6mvAVAIdxVlUEKxVllTa6AZACsLNzyrMAZCaReRKGPjiorm8ObmOSSpmzD34vxZBAMZCuKQi5zkiETME98bUpWqO2et7DWYU4JEnanBIrpiKQ14vNbFpCW4GUsZBH524ygZDZD'
  end

  # @param documents Array
  # Format:
  # [
  #     {
  #         language: 'en',
  #         id: 1,
  #         text: 'Hello world, im trying to calculate the sentiment of this buetifull post.'
  #     }
  # ]
  def get_posts_with_sentiment
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

    data = {
        documents: documents
    }

    response = JSON.parse(http.post(url.path, data.to_json, headers).body)

    response['documents'].each do |document|
      posts[document['id']]['sentiment'] = document['score']
    end

    posts
  end

  def avg_posts_sentiment
    sum = 0

    posts = get_posts_with_sentiment.values

    posts.each do |post|
      sum += post['sentiment']
    end

    sum / posts.length
  end
end
