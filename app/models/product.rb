
class Product < ApplicationRecord

  def eucledian_distance(personality1, personality2)
    Math.sqrt(
            ((personality1.extraversion - personality2.extraversion)**2) +
            ((personality1.agreeableness - personality2.agreeableness)**2) +
            ((personality1.conscientiousness- personality2.conscientiousness)**2) +
            ((personality1.neuroticism- personality2.neuroticism)**2)
    ).to_f.round(3)
  end
end
0