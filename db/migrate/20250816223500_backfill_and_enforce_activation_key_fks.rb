class BackfillAndEnforceActivationKeyFks < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def up
    # Backfill associations based on existing name fields.
    say_with_time "Backfilling activation_keys associations" do
      ActivationKey.reset_column_information
      Namespace.reset_column_information
      Library.reset_column_information
      Project.reset_column_information

      ActivationKey.find_each do |key|
        # Namespace (required)
        if key.namespace.present?
          ns = Namespace.where('LOWER(name) = ?', key.namespace.downcase).first || Namespace.create!(name: key.namespace)
          key.namespace_id = ns.id
        end
        # Library (required)
        if key.library_name.present?
          lib = Library.where('LOWER(name) = ?', key.library_name.downcase).first || Library.create!(name: key.library_name)
          key.library_id = lib.id
        end
        # Project (optional)
        if key.project_name.present?
          proj = Project.where('LOWER(name) = ?', key.project_name.downcase).first || Project.create!(name: key.project_name)
          key.project_id = proj.id
        end
        key.save!(validate: false)
      end
    end

    # Enforce NOT NULL on required FKs
    change_column_null :activation_keys, :library_id, false
    change_column_null :activation_keys, :namespace_id, false
  end

  def down
    change_column_null :activation_keys, :library_id, true
    change_column_null :activation_keys, :namespace_id, true
  end
end
