# == Schema Information
#
# Table name: level_quizzes
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string
#  content_ids :text             default([]), is an Array
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  created_by  :integer
#

require 'rails_helper'

RSpec.describe LevelQuiz, :type => :model do
  describe "factory" do
    let(:level_quiz) { build :level_quiz }
    it { expect(level_quiz).to be_valid }
  end
end
