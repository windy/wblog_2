class AddPhotoIdToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :photo_id, :integer
    add_index :comments, :photo_id
    add_foreign_key :comments, :photos
  end
end