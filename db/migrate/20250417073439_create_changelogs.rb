class CreateChangelogs < ActiveRecord::Migration[7.1]
  def change
    create_table :changelogs do |t|
      t.string :version, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.datetime :released_at, null: false
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :changelogs, :version, unique: true
  end
end
