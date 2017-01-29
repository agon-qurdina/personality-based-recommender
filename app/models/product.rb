class Product < ApplicationRecord

  # region Class Methods
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

  def self.avg_personalities
    Purchase.joins(:personality)
        .group('product_id')
        .select('purchases.product_id as product_id',
                'avg(personalities.agreeableness)     AS agreeableness',
                'avg(personalities.conscientiousness) AS conscientiousness',
                'avg(personalities.extraversion)      AS extraversion',
                'avg(personalities.neuroticism)       AS neuroticism',
                'avg(personalities.openness)          AS openness')
  end

  def self.avg_personality_for(product_id)
    avg_personalities.where(product_id: product_id)
  end

  def self.update_personalities!
    Product.all.each { |p| p.update_personality! }
  end

  # endregion

  # region Scopes
  def self.with_distance_from(personality_hash)
    products_with_distance_sql = Product.all
                                     .select('products.*',
                                             "|/(power(extraversion - #{personality_hash[:extraversion]}, 2) +
                                             power(agreeableness - #{personality_hash[:agreeableness]}, 2) +
                                             power(conscientiousness - #{personality_hash[:conscientiousness]}, 2) +
                                             power(neuroticism - #{personality_hash[:neuroticism]}, 2) +
                                             power(openness - #{personality_hash[:openness]}, 2)) AS distance")
                                     .to_sql

    self.from("(#{products_with_distance_sql}) as products")
  end

  # endregion

  def update_personality!
    new_personality = Product.avg_personality_for(id).to_a.first

    return false if new_personality.nil?

    self.update(new_personality.attributes.except('product_id', 'id'))
  end

  def avg_personality
    {
        openness: openness,
        conscientiousness: conscientiousness,
        extraversion: extraversion,
        agreeableness: agreeableness,
        neuroticism: neuroticism
    }
  end

  def get_closest_products
    products = Product.where('id != ?', self[:id]).to_a
    product_distances = {}
    products.each { |product| product_distances[product.id] = Personality.eucledian_distance self, product }
    product_distances = product_distances.sort_by { |k, v| v }.first(5).to_h
    keys = product_distances.keys
    final_products = []
    keys.each do |key|
      final_products.push products.select { |p| p.id == key }.first
    end
    final_products
  end
end
