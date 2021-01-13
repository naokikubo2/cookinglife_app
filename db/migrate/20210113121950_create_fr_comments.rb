class CreateFrComments < ActiveRecord::Migration[6.0]
  def change
    create_table :fr_comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :food_record, null: false, foreign_key: true
      t.text :content
      t.timestamps
    end
  end
end
