module Tutor
  class NotificationsController < TutorController::Base

    expose(:tutor_students) {
      current_user.tutor_requests_sent.accepted.map(&:user)
    }

    expose(:player) {
      player_id = (client_notification.data.any? && client_notification.data["player_id"]) ?
                  client_notification.data["player_id"] : nil

      if player_id
        Player.find(player_id)
      else
        nil
      end
    }

    expose(:player_test) {
      player.learning_quiz
    }

    expose(:student_ids) {
      tutor_students.map(&:id)
    }

    expose(:client_notifications) {
      ClientNotification.where(client: student_ids, deleted: false).order(created_at: :desc)
    }

    expose(:client_notification) {
      ClientNotification.find(params[:id])
    }

    def index
      render
    end

    def info
      render json: client_notifications,
      each_serializer: Api::ClientNotificationSerializer,
      root: "data"
    end

    def details
      type = client_notification.data_type
      if type == "client_test_completed"
        client_notification.update(opened: true)
        if !player.present?
          return render json: {
            message: 'Player not found',
          },
          status: 422
        end

        render json: {
          quiz_id: player.quiz_id,
          player_name: player.name,
          player_id: player.id,
          questions: quiz_fetcher.player_test_for_api,
          answers: player_test.answers,
          time: timeQuiz
        }

      elsif type == "client_message_open"
        client_notification.update(opened: true)
        message_id = client_notification.data['api_notification_id']
        message = Notification.find(message_id)
        render json: {
          title: message.title,
          description: message.description,
          seen_at: client_notification.created_at
        }

      elsif type == "client_got_item"
        client_notification.update(opened: true)
        achievement_id = client_notification.data['user_admin_achievement_id']
        achievement = UserAdminAchievement.find(achievement_id).admin_achievement
        render json: {
          name: achievement.name,
          description: achievement.description
        }

      elsif type == "client_recommended_contents_completed"
        client_notification.update(opened: true)
        client_tutor_recommendation_id = client_notification.data['client_tutor_recommendation_id']
        content_ids = get_content_ids(client_tutor_recommendation_id)
        contents = Content.find(content_ids)
        serialized_contents = ActiveModel::ArraySerializer.new(
          contents,
          each_serializer: Tutor::SimpleContentSerializer
        )
        render json: {
          contents: serialized_contents
        }
      else
        render json: {}
      end
    end

    def remove
      if client_notification.update(deleted: true)
        render json: {
          message: I18n.t("views.tutor.dashboard.card_tutor_notifications.notification_removed")
        }
      else
        render json: {
          message: I18n.t("views.tutor.dashboard.card_tutor_notifications.notification_removed_error")
        },
        status: 422
      end
    end

    private

    def quiz_fetcher
      TreeService::QuizFetcher.new(
        player
      )
    end


    def timeQuiz
      time_diff = player_test.updated_at - player_test.created_at
      Time.at(time_diff).utc.strftime("%H :%M :%S")
    end

    def get_content_ids(id)
      ClientTutorRecommendation.find(id)
                               .tutor_recommendation
                               .content_tutor_recommendations
                               .map(&:content_id)
    end

  end
end
