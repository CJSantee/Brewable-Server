class CreatePermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :permissions do |t|
      t.references :role, null: false, foreign_key: true
      t.string :permission

      t.timestamps
    end
  end
end
