class AddFieldQuantityToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :quantity, :integer, default: 1
  end
end
