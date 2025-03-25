class AddCoverImageToPosts < ActiveRecord::Migration[6.1]
  def up
    # Using Active Storage for cover images
    # No need to add fields to the posts table
    # The relationship is managed through active_storage_attachments table
    puts "Migration to enable cover images for posts using Active Storage"
  end

  def down
    # No need to perform any action in rollback
    # Active Storage attachments are not affected by this migration directly
    # To remove attachments, use rails active_storage:purge in a separate task
    puts "No action needed for rollback"
  end
end