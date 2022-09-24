class DefaultBeansUuid < ActiveRecord::Migration[6.1]
  def change
		enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
		change_column :beans, :beans_uuid, :string, default: 	`gen_random_uuid()`
  end
end
