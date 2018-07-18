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

FactoryGirl.define do
  factory :player do
    
  end

end
