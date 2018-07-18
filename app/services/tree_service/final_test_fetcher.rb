module TreeService
  class FinalTestFetcher

    def initialize(user)
      @user = user
    end

    def user_final_test_for_api
      if validate_achievement
        @user_test ||= Api::LearningTestSerializer.new(
          test_creator.user_test,
          root: false
        )
      end
    end

    private

    def test_creator
      FinalTestQuestionsCreator.new(
        user: @user,
        contents: contents_for_test
      )
    end

    def contents_for_test
      Neuron.approved_public_contents.shuffle[1..21]
    end

    def validate_achievement
      achievement = AdminAchievement.find_by_number(10)
      my_achievements = @user.user_admin_achievements.map(&:admin_achievement_id)
      my_achievements.include? achievement.id
    end
  end
end
