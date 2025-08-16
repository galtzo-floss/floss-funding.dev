class AddEcosystemToProjectsLibrariesNamespacesAndRewireKeys < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def up
    # Add ecosystem columns
    add_column :projects, :ecosystem, :string unless column_exists?(:projects, :ecosystem)
    add_column :libraries, :ecosystem, :string unless column_exists?(:libraries, :ecosystem)
    add_column :namespaces, :ecosystem, :string unless column_exists?(:namespaces, :ecosystem)

    say_with_time "Backfilling ecosystem on namespaces, libraries, and projects; and rewiring activation_keys" do
      ActivationKey.reset_column_information
      Project.reset_column_information
      Library.reset_column_information
      Namespace.reset_column_information

      ActivationKey.find_each do |key|
        eco = key.ecosystem

        # Namespace (required)
        if key.namespace.present?
          ns = Namespace.where('LOWER(name) = ? AND ecosystem = ?', key.namespace.downcase, eco).first
          unless ns
            # Try to reuse the previously linked namespace record by stamping its ecosystem
            ns_old = Namespace.where('LOWER(name) = ?', key.namespace.downcase).find_by(id: key.namespace_id)
            if ns_old && ns_old.ecosystem.blank?
              ns_old.update_columns(ecosystem: eco)
              ns = ns_old
            else
              ns = Namespace.create!(name: key.namespace, ecosystem: eco)
            end
          end
          key.update_columns(namespace_id: ns.id)
        end

        # Library (required)
        if key.library_name.present?
          lib = Library.where('LOWER(name) = ? AND ecosystem = ?', key.library_name.downcase, eco).first
          unless lib
            lib_old = Library.where('LOWER(name) = ?', key.library_name.downcase).find_by(id: key.library_id)
            if lib_old && lib_old.ecosystem.blank?
              lib_old.update_columns(ecosystem: eco)
              lib = lib_old
            else
              lib = Library.create!(name: key.library_name, ecosystem: eco)
            end
          end
          key.update_columns(library_id: lib.id)
        end

        # Project (optional)
        if key.project_name.present?
          proj = Project.where('LOWER(name) = ? AND ecosystem = ?', key.project_name.downcase, eco).first
          unless proj
            proj_old = Project.where('LOWER(name) = ?', key.project_name.downcase).find_by(id: key.project_id)
            if proj_old && proj_old.ecosystem.blank?
              proj_old.update_columns(ecosystem: eco)
              proj = proj_old
            else
              proj = Project.create!(name: key.project_name, ecosystem: eco)
            end
          end
          key.update_columns(project_id: proj.id)
        end
      end
    end

    # Enforce NOT NULL on new ecosystem columns and update indexes
    change_column_null :projects, :ecosystem, false
    change_column_null :libraries, :ecosystem, false
    change_column_null :namespaces, :ecosystem, false

    # Remove old unique indexes on name-only
    remove_index :projects, :name if index_exists?(:projects, :name)
    remove_index :libraries, :name if index_exists?(:libraries, :name)
    remove_index :namespaces, :name if index_exists?(:namespaces, :name)

    # Add composite unique indexes on (ecosystem, name)
    add_index :projects, [:ecosystem, :name], unique: true
    add_index :libraries, [:ecosystem, :name], unique: true
    add_index :namespaces, [:ecosystem, :name], unique: true
  end

  def down
    # Remove composite indexes
    remove_index :projects, column: [:ecosystem, :name] if index_exists?(:projects, [:ecosystem, :name])
    remove_index :libraries, column: [:ecosystem, :name] if index_exists?(:libraries, [:ecosystem, :name])
    remove_index :namespaces, column: [:ecosystem, :name] if index_exists?(:namespaces, [:ecosystem, :name])

    # Re-add name-only unique indexes
    add_index :projects, :name, unique: true
    add_index :libraries, :name, unique: true
    add_index :namespaces, :name, unique: true

    # Allow NULL ecosystem and drop columns
    change_column_null :projects, :ecosystem, true
    change_column_null :libraries, :ecosystem, true
    change_column_null :namespaces, :ecosystem, true

    remove_column :projects, :ecosystem
    remove_column :libraries, :ecosystem
    remove_column :namespaces, :ecosystem
  end
end
