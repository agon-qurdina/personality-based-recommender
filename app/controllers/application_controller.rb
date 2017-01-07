class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def test

    # Obtain yours from https://developers.facebook.com/tools/explorer?method=GET&path=me&version=v2.8
    oauth_access_token = 'EAACEdEose0cBAAt9aS5zP7ga4ZBnoGrXDFuZBpCZCAwOZCIknXIOf5FnSJFzFqQbdcgvpDtp5KW8YuZC9BLOUuuZAJSfdlRYRcvL6WFYUAZCDoRmUtYDqRtVEYulgjDibadkpt1mIcQgBDfLbIXNLezncAnHyQb4PRZC9sG3gBWflAZDZD'
    @graph = Koala::Facebook::API.new(oauth_access_token)

    profile = @graph.get_object("me")

    render json: profile
  end
end
