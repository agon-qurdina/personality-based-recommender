class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def test
    personality1 = Personality.where({id: 28}).first
    personality2 = Personality.where({id: 29}).first
    distance = Product.new.eucledian_distance(personality1, personality2)

    personality1 = Personality.where({id: 29}).first
    personality2 = Personality.where({id: 30}).first
    distance2 = Product.new.eucledian_distance(personality1, personality2)

    personality1 = Personality.where({id: 30}).first
    personality2 = Personality.where({id: 32}).first
    distance3 = Product.new.eucledian_distance(personality1, personality2)

    render json: {distance: distance, distance2: distance2, distance3: distance3}
  end
end
