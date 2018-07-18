# == Schema Information
#
# Table name: client_notifications
#
#  id         :integer          not null, primary key
#  client_id  :integer          not null
#  data_type  :integer          not null
#  data       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted    :boolean          default(FALSE)
#  opened     :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :client_notification do
    client { build :user}
  end
end
