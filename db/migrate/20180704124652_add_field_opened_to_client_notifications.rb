class AddFieldOpenedToClientNotifications < ActiveRecord::Migration
  def change
    add_column :client_notifications, :opened, :boolean, default: false
  end
end
