class CreateSpamWords < ActiveRecord::Migration[7.1]
  def change
    create_table :spam_words do |t|
      t.string :word
      t.string :replacement
      t.boolean :active

      t.timestamps
    end
  end
end
