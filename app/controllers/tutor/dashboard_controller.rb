module Tutor
  class DashboardController < TutorController::Base

    expose(:tutor_achievements) {
      current_user.tutor_achievements.order(created_at: :desc)
    }

    expose(:tutor_achievement_selected) {
      if params[:id]
        TutorAchievement.find(params[:id])
      else
        TutorAchievement.new
      end
    }

    expose(:tutor_students) {
      if (params[:ids].present?)
        User.where(id:params[:ids], role: :cliente)
      else
        current_user.tutor_requests_sent.accepted.map(&:user)
      end
    }

    expose(:tutor_students_with_status_not_deleted) {
      if (params[:ids].present?)
        User.where(id:params[:ids], role: :cliente)
      else
        current_user.tutor_requests_sent.not_deleted.map(&:user)
      end
    }

    expose(:tutor_achievement, attributes: :tutor_achievement_params)

    expose(:all_clients) {
      if params[:search]
        UserClientSearch.new(q:params[:search]).results
      else
        User.where(:role => :cliente)
      end
    }

    expose(:all_contents) {
      Neuron.approved_public_contents
    }

    expose(:student_ids) {
      tutor_students.map(&:id)
    }

    expose(:clients) {
      all_clients.where.not(
        id: tutor_students_with_status_not_deleted.map(&:id)
      ).page(params[:page])
    }

    expose(:unlearned_contents) {
      if params[:user_id]
        client = User.find(params[:user_id])
        unlearned = all_contents.where.not(
          id: client.content_learnings.map(&:content_id)
        )
        unlearned
      else
        all_contents
      end
    }

    expose(:questions) {
      if params[:content_ids]
        Content.where(id: params[:content_ids])
      else
        []
      end
    }

    expose(:level_quizzes) {
      LevelQuiz.order(created_at: :desc)
    }

    def achievements
      render json: {
        data: tutor_achievements
      }
    end

    def index
      render
    end

    def students
      render json: tutor_students_with_status_not_deleted,
      each_serializer: Tutor::DashboardStudentsSerializer,
      scope: current_user,
      root: "data"
    end

    def get_clients
      render json: {
        data: clients,
        meta: {
          total_items: clients.total_count,
          total_pages: clients.total_pages
        }
      }
    end

    def get_level_quizzes
      render json: {
        data: level_quizzes
      }
    end

    def get_questions
      render json: {
        data: questions
      }
    end

    def new_achievement
      if tutor_achievement.save!
        flash[:success] = I18n.t(
          "views.tutor.dashboard.achievement_request.created"
        )
      else
        flash[:error] = I18n.t("views.tutor.common.error")
      end

      redirect_to :back
    end

    def update_achievement
      achievement = TutorAchievement.find(params[:id])
      if achievement.update(tutor_achievement_params)
        flash[:success] = I18n.t(
          "views.tutor.dashboard.achievement_request.updated"
        )
      else
        flash[:error] = I18n.t("views.tutor.common.error")
      end
      redirect_to :back
    end

    def get_contents
      render json: {
        data: unlearned_contents
      }
    end

    def create_quiz
      quiz = Quiz.new
      player = Player.new
      client = User.find(quiz_params[:client_id])
      level = LevelQuiz.find(quiz_params[:level_quiz_id])
      player.client_id = client.id
      player.name = client.name || client.username
      quiz.level_quiz = level
      quiz.created_by = current_user
      quiz.players.push(player)

      if quiz.save
        quiz_url = decorate(player).link_to_test
        Notification.create!(user: current_user,
                            title: "#{I18n.t('views.tutor.dashboard.quizzes.title')} #{Date.today.to_s}",
                            description: "#{I18n.t('views.tutor.dashboard.quizzes.available')}: #{quiz_url}",
                            data_type: "tutor_quiz",
                            client_id: client.id)

        flash[:success] = I18n.t(
          "views.tutor.dashboard.quizzes.created",
          client_name: client.name,
          quiz_url: quiz_url
        )
      else
        flash[:error] = I18n.t("views.tutor.common.error")
      end

      render js: "window.location = '#{request.referrer}'"
    end

    def send_notification
      notification = Notification.new(notification_params)
      notification.user = current_user
      if student_ids_params.any?
        student_id = student_ids_params[0]
        notification.client_id = student_id
        notification.data_type = "tutor_generic"
        if notification.save
          flash[:success] = I18n.t(
            "views.tutor.dashboard.card_send_notifications.sent"
          )
        else
          flash[:error] = I18n.t("views.tutor.common.error")
        end
      else
        flash[:error] = I18n.t("views.tutor.common.error")
      end
      redirect_to :back
    end

    def download_tutor_analytics
      @statistics_by_user = []
      tutor_students.each do |student|
          statistics = student.generate_statistics(
            [
              "total_neurons_learnt",
              "total_contents_learnt",
              "contents_learnt_by_branch",
              "used_time",
              "average_used_time_by_content",
              "images_opened_in_count",
              "total_notes",
              "user_test_answers",
              "content_learnings_with_reading_times"
            ]
          )

          @statistics_by_user.push({
            student: student,
            statistics: statistics
          })
      end

      respond_to do |format|
        format.html
        format.xls
      end
    end

    private

    def tutor_achievement_params
      params.require(:tutor_achievement).permit(
        :name,
        :description,
        :image
      )
    end

    def notification_params
      params.require(:notification).permit(
        :title,
        :description,
        :notification_videos_attributes => [
          :url
        ],
        :notification_medium_attributes => [
          :media,
          :media_cache
        ]
      )
    end

    def student_ids_params
      params[:notification][:students] || []
    end

    def quiz_params
      params.require(:quiz).permit(*permitted_attributes)
    end

    def permitted_attributes
      [
        :level_quiz_id,
        :client_id
      ]
    end

  end
end
