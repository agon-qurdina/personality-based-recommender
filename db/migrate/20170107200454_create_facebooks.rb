class CreateFacebooks < ActiveRecord::Migration[5.0]
  def change
    create_table :facebooks do |t|
      t.belongs_to :user, index: true
      t.integer :fb_id
      t.integer :friends_count
      t.decimal :friends_density

      t.timestamps
    end
  end
end
