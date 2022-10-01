class PostCanHaveNullArchive < ActiveRecord::Migration[6.1]
  def change
		change_column_null :posts, :archived_at, true
  end
end
