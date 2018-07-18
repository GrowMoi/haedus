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



FactoryGirl.define do
  factory :level_quiz do
    sequence(:name) { |n|
      "Level #{n}"
    }
    sequence(:content_ids) { |n|
      [n]
    }

  end
end
