class AddLibraryNameToActivationKeys < ActiveRecord::Migration[8.0]
  def change
    add_column :activation_keys, :library_name, :string
  end
end
