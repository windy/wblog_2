class CreateChangelogItems < ActiveRecord::Migration[7.1]
  def change
    create_table :changelog_items do |t|
      t.references :changelog, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.string :item_type, null: false, default: 'feature'

      t.timestamps
    end
  end
end