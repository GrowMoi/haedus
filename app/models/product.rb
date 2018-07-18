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

class Product < ActiveRecord::Base

  CATEGORIES = %w(
    payments_website
  ).freeze

  begin :relationships
    has_many :payments
  end

  begin :validations
    validates :code, :key, uniqueness: true
    validates :name, presence: true,
                     uniqueness: true
    validates :category, presence: true,
                    inclusion: {in: CATEGORIES}
  end

  begin :callbacks
    before_create :set_code!
  end

  private

  def set_code!
    code = (0...6).map { (65 + rand(26)).chr }.join
    self.code = code
  end
end
