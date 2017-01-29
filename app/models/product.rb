class Product < ApplicationRecord

  def self.import
    products_csv = Roo::CSV.new(Rails.root.join('app/storage/product-export.csv'))

    (1..products_csv.last_row).each do |i|
      # (1..2).each do |i|

      product_row = products_csv.row(i)

      product_params = {
          title: product_row[0],
          description: product_row[1],
          image: product_row[2],
          price: product_row[3],
          source_url: product_row[4],

          extraversion: 0.0,
          agreeableness: 0.0,
          conscientiousness: 0.0,
          neuroticism: 0.0,
          openness: 0.0
      }

      Product.create(product_params)

      puts "Imported: #{i}"
    end
  end

  def get_closest_products
    products = Product.where('id != ?',self[:id]).to_a
    product_distances = {}
    products.each do |product|
      product_distances[product.id] = Personality.eucledian_distance self,product
    end
    product_distances = product_distances.sort_by { |k,v| v }.first(5).to_h
    keys = product_distances.keys
    final_products = []
    keys.each do |key|
      final_products.push products.select { |p| p.id == key}.first
    end
    final_products
  end
end
