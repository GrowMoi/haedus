class CreateSocialSharings < ActiveRecord::Migration
  def change
    create_table :social_sharings do |t|
      t.string :titulo, null: false
      t.string :descripcion
      t.string :uri, null: false
      t.string :imagen_url
      t.string :slug, index: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
