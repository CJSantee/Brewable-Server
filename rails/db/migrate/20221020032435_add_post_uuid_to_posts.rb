class AddPostUuidToPosts < ActiveRecord::Migration[6.1]
  def change
		add_column :posts, :post_uuid, :string, null: false
  end
end
