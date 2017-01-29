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
    products = Product.select('id,title,image,extraversion,agreeableness,conscientiousness,neuroticism,openness')
    product_distances = {}
    products.each { |product| product_distances[product.id] = eucledian_distance product }
    product_distances = product_distances.sort_by { |k, v| v }.to_h
    product_distances = product_distances.first(5)
    keys = product_distances.keys
    products = products.where('id IN (?)', keys)
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
