class AddEnableVotingToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :enable_voting, :boolean
  end
end
