class CreateContentLearningFinalTests < ActiveRecord::Migration
  def change
    create_table :content_learning_final_tests do |t|
      t.references :user,
                   null: false,
                   index: true,
                   foreign_key: true
      t.json :questions,
             null: false
      t.json :answers
      t.boolean :approved, default: false
      t.timestamps null: false
    end
  end
end
