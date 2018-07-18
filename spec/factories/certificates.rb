# == Schema Information
#
# Table name: certificates
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  media_url  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :certificate do
    
  end

end
