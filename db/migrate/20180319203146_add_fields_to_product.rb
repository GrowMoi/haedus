class AddFieldsToProduct < ActiveRecord::Migration
  def change
    add_column :products, :category, :string
    add_column :products, :description, :string
  end
end
