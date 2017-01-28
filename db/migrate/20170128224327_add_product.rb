class AddProduct < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :title
      t.string :description
      t.decimal :price
      t.decimal :avg_extraversion
      t.decimal :avg_agreeableness
      t.decimal :avg_conscientiousness
      t.decimal :avg_neuroticism
      t.decimal :avg_openness

      t.timestamps
    end
  end
end
