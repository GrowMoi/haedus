class AddClientToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :client_id, :integer
    add_foreign_key :notifications, :users, column: :client_id
  end
end
