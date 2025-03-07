class AddSessionIdToVotes < ActiveRecord::Migration[7.1]
  def change
    add_column :votes, :session_id, :string
    add_index :votes, [:post_id, :session_id]
  end
end