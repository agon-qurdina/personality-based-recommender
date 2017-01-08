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

  # Obtain yours from https://developers.facebook.com/tools/explorer?method=GET&path=me&version=v2.8
  def access_token
    'EAACEdEose0cBAJrIL6zUl7EnrON4XrCbHwGsRkZAEFRlnVpvdIZBSKZCq87HD62qpOGN5cqpsJDOgNNZAOvF59xInJNsEoeW7oovXdxr7Ip3xM5toFpSQbPQu9nttBU27g5k2iSzBHqSkOJFJixriIZBB6vgDNptEccL5v4a7oAZDZD'
  end
end
