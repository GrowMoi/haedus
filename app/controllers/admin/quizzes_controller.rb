module Admin
  class QuizzesController < AdminController::Base
    include Breadcrumbs

    before_action :add_breadcrumbs
    before_action :build_relationships!,
                  only: [:new]

    authorize_resource

    expose(:quiz, attributes: :quiz_params)
    expose(:quizzes) {
      Quiz.order(created_at: :desc)
    }

    def create
      quiz.created_by = current_user
      if quiz.save
        redirect_to admin_quiz_path(quiz), notice: I18n.t("views.quizzes.created")
      else
        render :new
      end
    end

    private

    def quiz_params
      params.require(:quiz).permit(*permitted_attributes)
    end

    def permitted_attributes
      allowed = [ :id,
                  :level_quiz_id,
                  :players_attributes => [
                    :id,
                    :name,
                    :_destroy
                  ]
                ]
    end

    def build_relationships!
      quiz.players.build
    end

    def resource
      @resource ||= quiz.id
    end

  end
end
