class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
			t.references :user, null: false, foreign_key: true
      t.string :caption
			t.datetime "archived_at", precision: 6, null: false
			
      t.timestamps
    end
  end
end
