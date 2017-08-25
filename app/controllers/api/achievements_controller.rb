module Api
  class AchievementsController < BaseController

    before_action :authenticate_user!

    PAGE = 1
    PER_PAGE = 5

    expose(:user_achievements) {
      Achievement.all
                .order(created_at: :desc)
                .page(params[:page] || PAGE)
                .per(params[:per_page] || PER_PAGE)
    }

    expose(:achievements_all) {
      result = []
      user_achievements.each do |user_achievement|
        result.push(user_achievement.achievement)
      end
      result
    }

    api :GET,
        "/achievements",
        "get user achievements"
    example %q{}
    def index
      result = serialize_achievements(user_achievements)
      render json: {
        achievements: result,
        meta: {
          total_count: user_achievements.total_count,
          total_pages: user_achievements.total_pages
        }
      }
    end

    private

    def serialize_achievements(achievements_data)
      serialized = ActiveModel::ArraySerializer.new(
        achievements_data,
        each_serializer: Api::AchievementSerializer,
        scope: current_user
      )
      serialized
    end

  end
end
