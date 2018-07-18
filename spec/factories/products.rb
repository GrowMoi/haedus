# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string
#  code        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category    :string
#  description :string
#  key         :string
#

FactoryGirl.define do
  factory :Product do
    
  end

end
