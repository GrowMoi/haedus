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

require 'rails_helper'

RSpec.describe Product, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
