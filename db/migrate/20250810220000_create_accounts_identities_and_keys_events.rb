class CreateAccountsIdentitiesAndKeysEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :email, null: false
      t.timestamps
    end
    add_index :accounts, :email, unique: true

    create_table :identities do |t|
      t.references :account, null: false, foreign_key: true
      t.string :email, null: false
      t.string :password_digest, null: false
      t.timestamps
    end
    add_index :identities, :email, unique: true

    create_table :activation_keys do |t|
      t.string :namespace, null: false
      t.string :key, null: false
      t.string :ecosystem, null: false
      t.integer :activation_event_count, null: false, default: 0
      t.integer :flags, null: false, default: 0
      t.timestamps default: -> { "CURRENT_TIMESTAMP" }
    end
    add_index :activation_keys, [:namespace, :key], unique: true

    create_table :activation_events do |t|
      t.references :activation_key, null: false, foreign_key: true
      t.references :account, null: true, foreign_key: true
      t.string :library_name
      t.integer :donation_amount
      t.string :donation_currency, null: false, default: "USD"
      t.string :ip_address
      t.integer :flags, null: false, default: 0
      t.timestamps default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
