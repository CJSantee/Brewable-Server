class AddPhotoUriToBeans < ActiveRecord::Migration[6.1]
  def change
    add_column :beans, :photo_uri, :string
  end
end
