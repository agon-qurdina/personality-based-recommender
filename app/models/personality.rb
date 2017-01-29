class Personality < ApplicationRecord

  COEFFICIENTS = {
      user_sentiment: {
          openness: 0.268,
          conscientiousness: -0.084,
          extraversion: 0.177,
          agreeableness: -0.130,
          neuroticism: -0.197
      },
      number_of_hashtags: {
          openness: -0.268,
          conscientiousness: -0.030,
          extraversion: 0.066,
          agreeableness: -0.044,
          neuroticism: -0.217
      },
      words_per_status: {
          openness: 0.200,
          conscientiousness: -0.144,
          extraversion: 0.285,
          agreeableness: -0.065,
          neuroticism: 0.031
      },
      links_per_status: {
          openness: 0.064,
          conscientiousness: 0.256,
          extraversion: -0.061,
          agreeableness: -0.081,
          neuroticism: -0.054
      },
      relationship_status: {
          openness: 0.093,
          conscientiousness: 0.071,
          extraversion: 0.194,
          agreeableness: 0.040,
          neuroticism: -0.036
      },
      last_name_length: {
          openness: 0.012,
          conscientiousness: -0.111,
          extraversion: 0.000,
          agreeableness: -0.044,
          neuroticism: 0.184
      },
      activities_length: {
          openness: 0.115,
          conscientiousness: 0.095,
          extraversion: 0.188,
          agreeableness: 0.066,
          neuroticism: -0.145
      },
      favorites_count: {
          openness: 0.158,
          conscientiousness: -0.093,
          extraversion: 0.019,
          agreeableness: 0.082,
          neuroticism: 0.028
      },
      number_of_friends: {
          openness: -0.094,
          conscientiousness: -0.078,
          extraversion: 0.186,
          agreeableness: 0.013,
          neuroticism: -0.069
      },
      network_density: {
          openness: -0.152,
          conscientiousness: 0.050,
          extraversion: -0.224,
          agreeableness: 0.059,
          neuroticism: 0.032
      },
  }

  def coefficients
    COEFFICIENTS
  end

  def self.eucledian_distance(personality1, personality2)
    Math.sqrt(
        ((personality1[:extraversion] - personality2[:extraversion])**2) +
            ((personality1[:agreeableness] - personality2[:agreeableness])**2) +
            ((personality1[:conscientiousness]- personality2[:conscientiousness])**2) +
            ((personality1[:neuroticism]- personality2[:neuroticism])**2) +
            ((personality1[:openness]- personality2[:openness])**2)
    ).to_f.round(3)
  end
end
