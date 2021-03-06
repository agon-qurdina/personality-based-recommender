# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

start = Time.now

Product.first(5000).each_with_index do |product, i|
  avg_personality = Purchase.get_avg_personality product.id
  product.agreeableness=avg_personality[:agreeableness]
  product.conscientiousness=avg_personality[:conscientiousness]
  product.neuroticism=avg_personality[:neuroticism]
  product.extraversion=avg_personality[:extraversion]
  product.openness=avg_personality[:openness]
  product.save!
  puts i
end
elaspsed = Time.now - start
puts elaspsed.to_s + ' seconds'
return

300.times do
  User.create!({ email: Faker::Internet.email, password: Devise.friendly_token.first(8) })
end

min, max = [-0.268, 0.285]

users = User.all.each do |user|
  user.create_personality({
                              openness: (rand * (max-min) + min).round(3),
                              conscientiousness: (rand * (max-min) + min).round(3),
                              extraversion: (rand * (max-min) + min).round(3),
                              agreeableness: (rand * (max-min) + min).round(3),
                              neuroticism: (rand * (max-min) + min).round(3)
                          })
end

products = Product.all.select('id,price')

30000.times do
  Purchase.create!({
                       user_id: users[rand(300)].id,
                       product_id: (product = products[rand(5000)]).id,
                       quantity: Faker::Number.between(1, 4).to_i,
                       price: product.price
                   })
end
