class Product < ApplicationRecord

  def get_closest_products
    products = Product.where('id != ?',self[:id]).select('id,title,image,extraversion,agreeableness,conscientiousness,neuroticism,openness')
    product_distances = {}
    products.each { |product| product_distances[product.id] = Personality.eucledian_distance self,product }
    product_distances = product_distances.sort_by { |k,v| v }.first(5).to_h
    keys = product_distances.keys
    final_products = []
    keys.each do |key|
      final_products.push products.where({id: key}).first
    end
    final_products
  end
end
