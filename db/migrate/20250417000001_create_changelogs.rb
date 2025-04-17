class CreateChangelogs < ActiveRecord::Migration[7.1]
  def change
    create_table :changelogs do |t|
      t.string :version, null: false
      t.string :title, null: false
      t.string :status, null: false, default: 'rolling'
      t.datetime :released_at

      t.timestamps
    end
    
    add_index :changelogs, :version, unique: true
  end
end