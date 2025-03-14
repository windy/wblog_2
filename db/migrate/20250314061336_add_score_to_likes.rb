class AddScoreToLikes < ActiveRecord::Migration[7.1]
  def change
    add_column :likes, :score, :integer
  end
end
