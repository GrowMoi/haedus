module Admin
  class LevelQuizzesController < AdminController::Base
    include Breadcrumbs

    before_action :add_breadcrumbs

    authorize_resource

    expose(:level_quiz, attributes: :level_quiz_params)
    expose(:level_quizzes) {
      LevelQuiz.order(created_at: :desc)
    }

    expose(:contents) {
      Neuron.approved_public_contents
    }

    expose(:questions) {
      Content.where(id: level_quiz.content_ids)
    }

    def create
      if level_quiz.save
        redirect_to admin_level_quiz_path(level_quiz), notice: I18n.t("views.level_quizzes.created")
      else
        render :new
      end
    end

    def update
      level_quiz.created_by = current_user
      if level_quiz.save
        redirect_to admin_level_quiz_path(level_quiz), notice: I18n.t("views.level_quizzes.updated")
      else
        render :edit
      end
    end

    private

    def level_quiz_params
      params.require(:level_quiz).permit(*permitted_attributes)
    end

    def permitted_attributes
      allowed = [ :name,
                  :description,
                  content_ids: []
                ]
    end

    def resource
      @resource ||= level_quiz.id
    end

  end
end
