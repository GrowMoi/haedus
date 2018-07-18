class CreateStorages < ActiveRecord::Migration
  def change
    create_table :storages do |t|
      t.references :user, index: true, null: false
      t.json :frontendValues
      t.timestamps null: false
    end
  end
end
