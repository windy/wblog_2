class CreateVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :votes do |t|
      t.references :post, null: false, foreign_key: true
      t.integer :vote_type
      t.string :session_id

      t.timestamps
    end
  end
end
