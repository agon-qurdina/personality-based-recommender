class Personality < ApplicationRecord
  def coefficients
    @coefficients ||= begin
      coeff = {}

      coeff[:user_sentiment] = {}
      coeff[:user_sentiment][:openness]=0.268
      coeff[:user_sentiment][:conscientiousness]=-0.084
      coeff[:user_sentiment][:extraversion]=0.177
      coeff[:user_sentiment][:agreeableness]=-0.130
      coeff[:user_sentiment][:neuroticism]=-0.197

      coeff[:number_of_hashtags] = {}
      coeff[:number_of_hashtags][:openness]=-0.268
      coeff[:number_of_hashtags][:conscientiousness]=-0.030
      coeff[:number_of_hashtags][:extraversion]=0.066
      coeff[:number_of_hashtags][:agreeableness]=-0.044
      coeff[:number_of_hashtags][:neuroticism]=-0.217

      coeff[:words_per_status] = {}
      coeff[:words_per_status][:openness]=0.200
      coeff[:words_per_status][:conscientiousness]=-0.144
      coeff[:words_per_status][:extraversion]=0.285
      coeff[:words_per_status][:agreeableness]=-0.065
      coeff[:words_per_status][:neuroticism]=0.031

      coeff[:links_per_status] = {}
      coeff[:links_per_status][:openness]=0.064
      coeff[:links_per_status][:conscientiousness]=0.256
      coeff[:links_per_status][:extraversion]=-0.061
      coeff[:links_per_status][:agreeableness]=-0.081
      coeff[:links_per_status][:neuroticism]=-0.054

      coeff[:relationship_status] = {}
      coeff[:relationship_status][:openness]=0.093
      coeff[:relationship_status][:conscientiousness]=0.071
      coeff[:relationship_status][:extraversion]=0.194
      coeff[:relationship_status][:agreeableness]=0.040
      coeff[:relationship_status][:neuroticism]=-0.036

      coeff[:last_name_length] = {}
      coeff[:last_name_length][:openness]=0.012
      coeff[:last_name_length][:conscientiousness]=-0.111
      coeff[:last_name_length][:extraversion]=0.000
      coeff[:last_name_length][:agreeableness]=-0.044
      coeff[:last_name_length][:neuroticism]=0.184

      coeff[:activities_length] = {}
      coeff[:activities_length][:openness]=0.115
      coeff[:activities_length][:conscientiousness]=0.095
      coeff[:activities_length][:extraversion]=0.188
      coeff[:activities_length][:agreeableness]=0.066
      coeff[:activities_length][:neuroticism]=-0.145

      coeff[:favorites_count] = {}
      coeff[:favorites_count][:openness]=0.158
      coeff[:favorites_count][:conscientiousness]=-0.093
      coeff[:favorites_count][:extraversion]=0.019
      coeff[:favorites_count][:agreeableness]=0.082
      coeff[:favorites_count][:neuroticism]=0.028

      coeff[:number_of_friends] = {}
      coeff[:number_of_friends][:openness]=-0.094
      coeff[:number_of_friends][:conscientiousness]=-0.078
      coeff[:number_of_friends][:extraversion]=0.186
      coeff[:number_of_friends][:agreeableness]=0.013
      coeff[:number_of_friends][:neuroticism]=-0.069

      coeff[:network_density] = {}
      coeff[:network_density][:openness]=-0.152
      coeff[:network_density][:conscientiousness]=0.050
      coeff[:network_density][:extraversion]=-0.224
      coeff[:network_density][:agreeableness]=0.059
      coeff[:network_density][:neuroticism]=0.032

      coeff
    end
  end
end
