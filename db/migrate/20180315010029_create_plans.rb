class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.string :code
      t.timestamps null: false
    end
  end
end
