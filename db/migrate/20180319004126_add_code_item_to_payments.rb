class AddCodeItemToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :code_item, :integer
  end
end
