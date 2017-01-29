class Product < ApplicationRecord

  def get_closest_products
    products = Product.select('id,title,image,extraversion,agreeableness,conscientiousness,neuroticism,openness')
    product_distances = {}
    products.each { |product| product_distances[product.id] = eucledian_distance product }
    product_distances = product_distances.sort_by { |k,v| v }.to_h
    product_distances = product_distances.first(5)
    keys = product_distances.keys
    products = products.where('id IN (?)',keys)
  end

  def eucledian_distance(product)
    Math.sqrt(
        ((self.extraversion - product.extraversion)**2) +
            ((self.agreeableness - product.agreeableness)**2) +
            ((self.conscientiousness- product.conscientiousness)**2) +
            ((self.neuroticism- product.neuroticism)**2) +
            ((self.openness- product.openness)**2)
    ).to_f.round(3)
  end
end
