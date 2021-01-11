class CreateFsComments < ActiveRecord::Migration[6.0]
  def change
    create_table :fs_comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :food_share, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
