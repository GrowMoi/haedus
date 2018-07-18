# == Schema Information
#
# Table name: Products
#
#  id         :integer          not null, primary key
#  name       :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module Api
  class PlanSerializer < ActiveModel::Serializer
    attributes :name,
               :code
  end
end
