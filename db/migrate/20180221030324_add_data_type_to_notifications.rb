class AddDataTypeToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :data_type, :string
  end
end
