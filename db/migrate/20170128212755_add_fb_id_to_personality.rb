class AddFbIdToPersonality < ActiveRecord::Migration[5.0]
  def change
    add_column :personalities, :fb_id, :text
  end
end
