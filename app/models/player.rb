# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  score      :float
#  quiz_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :integer
#

class Player < ActiveRecord::Base
  belongs_to :quiz

  begin :validations
    validates :name,
              presence: true
  end

  begin :relationships
    has_one :learning_quiz,
             dependent: :destroy,
             class_name: "ContentLearningQuiz"
  end
end
