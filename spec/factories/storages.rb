# == Schema Information
#
# Table name: storages
#
#  id             :integer          not null, primary key
#  user_id        :integer          not null
#  frontendValues :json
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :storage do
    
  end

end
