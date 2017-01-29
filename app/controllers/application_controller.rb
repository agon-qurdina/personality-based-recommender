class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def test
    # Product.import

    # Calculates AVG personalities based on purchases and updates products
    # Product.update_personalities!

    # Order products by personality usage
    Product.with_distance_from(Product.first.avg_personality).order('distance desc').first(5)

    Product.with_distance_from(User.first.personality_hash)



    return render text: 'done'

    render json: { distances: distances }
  end
end
