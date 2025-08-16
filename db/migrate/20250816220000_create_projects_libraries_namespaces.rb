class CreateProjectsLibrariesNamespaces < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :projects, :name, unique: true

    create_table :libraries do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :libraries, :name, unique: true

    create_table :namespaces do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :namespaces, :name, unique: true

    change_table :activation_keys do |t|
      t.references :project, null: true, foreign_key: true
      t.references :library, null: true, foreign_key: true
      t.references :namespace, null: true, foreign_key: true
    end
  end
end
