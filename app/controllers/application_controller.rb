class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def test
    # Product.import


    return render text: Product.update_personalities!

    render json: { distances: distances }
  end
end
