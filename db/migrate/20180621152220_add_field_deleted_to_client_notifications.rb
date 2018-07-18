class AddFieldDeletedToClientNotifications < ActiveRecord::Migration
  def change
    add_column :client_notifications, :deleted, :boolean, default: false
  end
end
