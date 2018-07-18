# == Schema Information
#
# Table name: client_quizzes
#
#  id         :integer          not null, primary key
#  client_id  :integer          not null
#  quiz_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ClientQuiz < ActiveRecord::Base
  belongs_to :client,
             class_name: "User",
             foreign_key: "client_id"

  belongs_to :quiz
end
