class CreatePersonalities < ActiveRecord::Migration[5.0]
  def change
    create_table :personalities do |t|
      t.belongs_to :user, index: true
      t.decimal :extraversion
      t.decimal :agreeableness
      t.decimal :conscientiousness
      t.decimal :neuroticism
      t.decimal :openness

      t.timestamps
    end
  end
end
