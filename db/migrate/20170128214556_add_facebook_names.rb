class AddFacebookNames < ActiveRecord::Migration[5.0]
  def change
    add_column :facebooks, :first_name, :text
    add_column :facebooks, :last_name, :text
    add_column :personalities, :first_name, :text
    add_column :personalities, :last_name, :text
  end
end
