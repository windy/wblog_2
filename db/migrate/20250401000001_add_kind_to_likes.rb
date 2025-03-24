class AddKindToLikes < ActiveRecord::Migration[6.1]
  def change
    add_column :likes, :kind, :string, default: 'like', null: false
    
    # Update existing records to have 'like' kind
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE likes SET kind = 'like' WHERE kind IS NULL;
        SQL
      end
    end
  end
end