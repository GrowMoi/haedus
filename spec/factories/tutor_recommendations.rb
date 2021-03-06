# == Schema Information
#
# Table name: tutor_recommendations
#
#  id                   :integer          not null, primary key
#  tutor_id             :integer          not null
#  tutor_achievement_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

FactoryGirl.define do
  factory :tutor_recommendation do
    tutor { build :user }
  end

end
