class Purchase < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :personality, foreign_key: 'user_id', class_name: 'Personality', primary_key: 'user_id'

  def self.get_avg_personality(product_id)
    avg_personality = { agreeableness: 0.0, conscientiousness: 0.0, neuroticism: 0.0, extraversion: 0.0, openness: 0.0 }
    product_users = Purchase.where({ product_id: product_id }).select('distinct user_id')
    Personality.where('user_id IN (?)', product_users).select('extraversion,agreeableness,conscientiousness,neuroticism,openness').each do |personality|
      avg_personality[:agreeableness] += personality.agreeableness
      avg_personality[:conscientiousness] += personality.conscientiousness
      avg_personality[:neuroticism] += personality.neuroticism
      avg_personality[:extraversion] += personality.extraversion
      avg_personality[:openness] += personality.openness
    end
    avg_personality[:agreeableness] = (avg_personality[:agreeableness] / product_users.length).to_f.round(3)
    avg_personality[:conscientiousness] = (avg_personality[:conscientiousness] / product_users.length).to_f.round(3)
    avg_personality[:neuroticism] = (avg_personality[:neuroticism] / product_users.length).to_f.round(3)
    avg_personality[:extraversion] = (avg_personality[:extraversion] / product_users.length).to_f.round(3)
    avg_personality[:openness] = (avg_personality[:openness] / product_users.length).to_f.round(3)
    avg_personality
  end
end