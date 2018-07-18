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

require 'rails_helper'

RSpec.describe ClientNotification, type: :model do
  describe "factory" do
    let(:client_notification) { build :client_notification }
    it { expect(client_notification).to be_valid }
  end
end
