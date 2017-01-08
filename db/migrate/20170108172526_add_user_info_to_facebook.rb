class AddUserInfoToFacebook < ActiveRecord::Migration[5.0]
  def change
    add_column :facebooks, :relationship_status, :boolean
    add_column :facebooks, :last_name_length, :integer
    add_column :facebooks, :activties_length, :integer
    add_column :facebooks, :favorites_count, :integer
  end
end
