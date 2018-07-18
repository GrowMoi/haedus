class AddClientToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :client_id, :integer
    add_foreign_key :players, :users, column: :client_id
  end
end
