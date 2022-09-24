class AddBeansUuidToBeans < ActiveRecord::Migration[6.1]
  def change
    add_column :beans, :beans_uuid, :string
  end
end
