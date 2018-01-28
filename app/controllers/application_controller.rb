class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def test
    # Product.import

    # Calculates AVG personalities based on purchases and updates products
    #Product.update_personalities!

    # Order products by personality usage
    # products = Product.with_distance_from(Product.first.avg_personality).to_a

    # Product.with_distance_from(User.first.personality_hash)

    @products = Product.with_distance_from(current_user.personality_hash).order('distance').select('id,extraversion,agreeableness,conscientiousness,neuroticism,openness,distance').limit(10).to_a

    @user = current_user.personality_hash

    render 'user/test', layout: false and return


    render json: { user: current_user.personality_hash, products_to_user: @products }
  end
end
