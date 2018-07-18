class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.references :user, index: true, null: false
      t.string :media_url, null: false
      t.timestamps null: false
    end
  end
end
