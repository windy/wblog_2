class AddSensitiveWordsFieldsToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :filtered_content, :text
    add_column :comments, :has_sensitive_words, :boolean
    add_column :comments, :sensitive_word_count, :integer
  end
end
