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

class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  begin :validations
    validates :payment_id,
              :source,
              :total,
              :code_item,
              :quantity,
              presence: true
  end

end
