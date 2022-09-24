class UndoDefaultBeansUuid < ActiveRecord::Migration[6.1]
  def change
		disable_extension 'pgcrypto'
		change_column :beans, :beans_uuid, :string, default: nil
  end
end
