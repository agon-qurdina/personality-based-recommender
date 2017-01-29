class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :title
      t.string :description
      t.string :code
      t.string :image

      t.decimal :extraversion
      t.decimal :agreeableness
      t.decimal :conscientiousness
      t.decimal :nueroticism
      t.decimal :openness

      t.timestamps
    end
  end
end
