class AddStatusToMatchings < ActiveRecord::Migration[6.0]
  def change
    add_column :matchings, :status, :string, null: false
  end
end
