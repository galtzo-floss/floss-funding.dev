class AddOssFieldsToActivationKeys < ActiveRecord::Migration[8.0]
  def change
    add_column :activation_keys, :project_name, :string
    add_column :activation_keys, :project_url, :string
  end
end
