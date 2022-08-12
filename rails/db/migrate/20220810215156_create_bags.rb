class CreateBags < ActiveRecord::Migration[6.1]
  def change
    create_table :bags do |t|
			t.references :bean
			t.references :user
      t.string :roast_level
			t.date :roast_date
			t.integer :price
			t.decimal :weight
			t.string :weight_unit
			t.integer :rating
			t.string :photo_uri
			t.boolean :favorite

      t.timestamps
    end
  end
end
