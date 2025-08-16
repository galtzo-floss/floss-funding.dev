class AddRetiredToActivationKeys < ActiveRecord::Migration[8.0]
  def change
    add_column :activation_keys, :retired, :boolean, null: false, default: false
    add_index :activation_keys, :retired
  end
end
