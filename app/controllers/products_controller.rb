class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :test_personality]
  before_action :authenticate_user!, only: [:purchase, :index]

  def home
  end

  # GET /products
  # GET /products.json
  def index
    @products = Product.with_distance_from(current_user.personality_hash).order('distance').limit(10).to_a
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @similar_products = Product.with_distance_from(@product.avg_personality).where('id != ?', @product.id).order('distance').first(5)
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.extraversion=0.0
    @product.agreeableness=0.0
    @product.conscientiousness=0.0
    @product.neuroticism=0.0
    @product.openness=0.0
    respond_to do |format|
      if @product.save
        format.html { redirect_to action: :index, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def purchase
    product = Product.find(params[:product_id])

    purchase = Purchase.new
    purchase.user_id = current_user.id
    purchase.product_id = product.id
    purchase.quantity = 1
    purchase.price = 0.0
    purchase.save!

    avg_personality = Purchase.get_avg_personality product.id
    product.agreeableness=avg_personality[:agreeableness]
    product.conscientiousness=avg_personality[:conscientiousness]
    product.neuroticism=avg_personality[:neuroticism]
    product.extraversion=avg_personality[:extraversion]
    product.openness=avg_personality[:openness]
    product.save!

    render json: { success: true }
  end

  def test_personality
    @products = Product.with_distance_from(@product.avg_personality)
                    .where('id != ?', @product.id).order('distance')
                    .limit(10).to_a
    render 'products/test', layout: false
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:product).permit(:title, :description, :code, :image)
  end
end
