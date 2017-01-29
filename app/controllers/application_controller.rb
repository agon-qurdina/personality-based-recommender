class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def test
    # Product.import
    return render json:  #Faker::Number.decimal(0, 3).to_f

    personality1 = Personality.where({ id: 28 }).first
    personality2 = Personality.where({ id: 29 }).first
    personality3 = Personality.where({ id: 30 }).first
    personality4 = Personality.where({ id: 32 }).first
    personality5 = Personality.where({ id: 33 }).first
    personality6 = Personality.where({ id: 36 }).first
    personality7 = Personality.where({ id: 37 }).first

    distances = []
    distances.push Product.new.eucledian_distance(personality1, personality2)
    distances.push Product.new.eucledian_distance(personality1, personality3)
    distances.push Product.new.eucledian_distance(personality1, personality4)
    distances.push Product.new.eucledian_distance(personality2, personality3)
    distances.push Product.new.eucledian_distance(personality2, personality4)
    distances.push Product.new.eucledian_distance(personality3, personality4)
    distances.push Product.new.eucledian_distance(personality4, personality5)
    distances.push Product.new.eucledian_distance(personality5, personality6)
    distances.push Product.new.eucledian_distance(personality6, personality7)

    render json: { distances: distances }
  end
end
