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

require 'rails_helper'

RSpec.describe ContentLearningFinalTest, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
