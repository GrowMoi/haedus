# == Schema Information
#
# Table name: content_learning_final_tests
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  questions  :json             not null
#  answers    :json
#  approved   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :content_learning_final_test do
    
  end

end
