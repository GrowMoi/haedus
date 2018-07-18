class AddRelationProductPayment < ActiveRecord::Migration
  def change
    add_reference :payments,
                  :product
  end
end
