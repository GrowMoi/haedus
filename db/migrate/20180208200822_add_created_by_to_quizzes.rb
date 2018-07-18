class AddCreatedByToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :created_by, :integer
    add_foreign_key :quizzes, :users, column: :created_by
  end
end
