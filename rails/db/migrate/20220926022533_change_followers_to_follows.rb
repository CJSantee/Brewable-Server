class ChangeFollowersToFollows < ActiveRecord::Migration[6.1]
  def change
		rename_table :followers, :follows
  end
end
