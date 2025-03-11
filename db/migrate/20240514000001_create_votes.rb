class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :post
      t.string :session_id
      t.string :option

      t.timestamps
    end

    add_index :votes, [:session_id, :post_id], unique: true
  end
end