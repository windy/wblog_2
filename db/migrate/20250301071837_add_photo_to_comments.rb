class AddPhotoToComments < ActiveRecord::Migration[7.1]
  def change
    add_reference :comments, :photo, null: false, foreign_key: true
  end
end
