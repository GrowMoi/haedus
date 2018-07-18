class AddCreatedByToLevelQuizzes < ActiveRecord::Migration
  def change
    add_column :level_quizzes, :created_by, :integer
    add_foreign_key :level_quizzes, :users, column: :created_by
  end
end
