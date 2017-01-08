class ChangeFbIdType < ActiveRecord::Migration[5.0]
  def change
    change_column :facebooks, :fb_id, :text
  end
end
