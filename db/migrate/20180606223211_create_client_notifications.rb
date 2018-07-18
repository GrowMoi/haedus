class CreateClientNotifications < ActiveRecord::Migration
  def change
    create_table :client_notifications do |t|
      t.references :client, index: true, null: false
      t.integer :data_type, null: false
      t.json :data
      t.timestamps null: false
    end
    add_foreign_key :client_notifications, :users, column: :client_id
  end
end
