class CreateChangelogs < ActiveRecord::Migration[7.1]
  def change
    create_table :changelogs do |t|
      t.date :date, null: false
      t.string :category, null: false
      t.text :content, null: false

      t.timestamps
    end
    add_index :changelogs, :date
  end
end
