class ChangeTypeCode < ActiveRecord::Migration
  def change
    change_column :payments, :code_item, :string
  end
end
