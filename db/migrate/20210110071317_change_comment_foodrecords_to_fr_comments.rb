class ChangeCommentFoodrecordsToFrComments < ActiveRecord::Migration[6.0]
  def change
    rename_table :comment_foodrecords, :fr_comments
  end
end
