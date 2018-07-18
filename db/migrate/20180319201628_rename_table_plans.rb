class RenameTablePlans < ActiveRecord::Migration
  def change
    rename_table :plans, :products
  end
end
