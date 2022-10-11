class UpdateUsersTable < ActiveRecord::Migration[6.1]
  def change
		add_column :users, :archived_at, :datetime, null: true
		add_column :users, :is_private, :boolean, null: false, :default => false
		add_column :users, :bio, :string, null: true
		add_column :users, :time_zone, :string, null: false, :default => "America/New_York"
  end
end
