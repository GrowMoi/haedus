class CreateContentImportings < ActiveRecord::Migration
  def change
    create_table :content_importings do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.string :status, null: false
      t.string :file
      t.text :imported_contents_ids, array: true, default: []

      t.timestamps null: false
    end
  end
end
