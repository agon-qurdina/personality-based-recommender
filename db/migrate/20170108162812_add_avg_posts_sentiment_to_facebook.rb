class AddAvgPostsSentimentToFacebook < ActiveRecord::Migration[5.0]
  def change
    add_column :facebooks, :avg_posts_sentiment, :decimal
  end
end
