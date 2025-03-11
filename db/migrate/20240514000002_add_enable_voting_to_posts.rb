class AddEnableVotingToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :enable_voting, :boolean, default: false
  end
end