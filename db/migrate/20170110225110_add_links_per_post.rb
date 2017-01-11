class AddLinksPerPost < ActiveRecord::Migration[5.0]
  def change
    add_column :facebooks, :links_per_post, :decimal
    add_column :facebooks, :hashtags_per_post, :decimal
    add_column :facebooks, :words_per_post, :decimal
  end
end
