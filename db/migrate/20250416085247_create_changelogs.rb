class CreateChangelogs < ActiveRecord::Migration[7.1]
  def change
    create_table :changelogs do |t|
      t.date :date
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
