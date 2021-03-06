class CreateAdminAchievements < ActiveRecord::Migration
  def change
    create_table :admin_achievements do |t|
      t.string :name, null: false
      t.text :description
      t.string :image
      t.string :category
      t.integer :number
      t.boolean :active, default: true
      t.json :settings
      t.timestamps null: false
    end
  end
end
