# == Schema Information
#
# Table name: admin_achievements
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text
#  image       :string
#  category    :string
#  settings    :json
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class AdminAchievement < ActiveRecord::Base

  CATEGORIES = [
    'content',
    'test',
    'time'
  ].freeze

  begin :enumerables
    enum categories: CATEGORIES
  end

  has_paper_trail ignore: [:created_at, :updated_at, :id]

  mount_uploader :image, ContentMediaUploader

  begin validations
    validates :name, :category, :settings,
              presence: true
    validates :category,
              inclusion: { in: CATEGORIES }
  end


  ##
  # user learnt first 4 contents
  def learnt_four_content(user)
    user.content_learnings.count >= 4
  end

  ##
  # user gave 50 tests
  def fifty_tests_given(user)
    user.learning_tests.count >= 50
  end

  ##
  # user gave 4 tests without errors
  def four_successful_tests(user)
    user.continuous_successful_tests(4)
  end

end
