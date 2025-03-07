class CreateVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :votes do |t|
      t.references :poll_option, null: false, foreign_key: true
      t.string :session_id

      t.timestamps
    end
  end
end
