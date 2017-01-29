class AddSourceUrlToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :source_url, :string
  end
end
