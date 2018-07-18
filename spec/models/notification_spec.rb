# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  media_count :integer          default(0)
#  user_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  client_id   :integer
#  data_type   :string
#

require 'rails_helper'

RSpec.describe Notification, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
