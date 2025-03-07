class CreatePolls < ActiveRecord::Migration[7.1]
  def change
    create_table :polls do |t|
      t.references :post, null: false, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
