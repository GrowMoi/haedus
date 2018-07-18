# == Schema Information
#
# Table name: payments
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  payment_id :string
#  source     :string
#  total      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  code_item  :string
#  quantity   :integer          default(1)
#  product_id :integer
#

require 'rails_helper'

RSpec.describe Payment, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
