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

class Storage < ActiveRecord::Base
  begin :relationships
    belongs_to :user
  end
end
