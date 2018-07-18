class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :user, index: true, null: false
      t.string :payment_id
      t.string :source
      t.float :total
      t.timestamps null: false
    end
  end
end
