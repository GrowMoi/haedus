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

require 'rails_helper'

RSpec.describe Storage, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
