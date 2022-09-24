class RenameBeansPhotoUri < ActiveRecord::Migration[6.1]
  def change
		rename_column :beans, :photo_uri, :image_uri
		rename_column :bags, :photo_uri, :image_uri
  end
end
