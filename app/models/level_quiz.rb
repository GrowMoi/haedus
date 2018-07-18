# == Schema Information
#
# Table name: level_quizzes
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string
#  content_ids :text             default([]), is an Array
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  created_by  :integer
#

class LevelQuiz < ActiveRecord::Base
  begin :relationships
    has_many :quizzes
  end

  begin :validations
    validates :name, presence: true, uniqueness: true
    validates :content_ids, presence: true
  end
end
