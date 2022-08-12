class CreateBeans < ActiveRecord::Migration[6.1]
  def change
    create_table :beans do |t|
      t.string :name
			t.string :roaster
			t.string :origin
			t.string :flavor_notes
			
      t.timestamps
    end
  end
end
