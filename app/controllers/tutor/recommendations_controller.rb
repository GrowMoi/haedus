module Tutor
  class RecommendationsController < TutorController::Base

    expose(:contents) {
      Neuron.approved_public_contents
    }

    expose(:tutor_achievements) {
      current_user.tutor_achievements.order(created_at: :desc)
    }

    expose :tutor_recommendation

    expose(:clients) {
      UserTutor.where(tutor: current_user, status: :accepted)
    }

    expose(:students_selected) {
      User.where(id: student_ids_params)
    }

    expose(:tutor_achievement, attributes: :tutor_achievement_params)

    def new
      render
    end

    def create
      tutor_recommendation.tutor = current_user
      achievement_id = tutor_recommendation_params[:tutor_achievement]
      if !achievement_id.empty?
        achievement = TutorAchievement.find(achievement_id)
        tutor_recommendation.tutor_achievement = achievement
      end

      content_ids = tutor_recommendation_params[:content_tutor_recommendations]
      content_ids = remove_blank(content_ids)
      students_ids = tutor_recommendation_params[:students]
      students_ids = remove_blank(students_ids)

      if content_ids.any? && students_ids.any?
        create_tutor_recommendation(tutor_recommendation, content_ids, students_ids)
      else
        flash[:error] = I18n.t("views.tutor.recommendations.recommendation_request.missing_params")
      end
      if request.xhr?
        render :js => "window.location = '#{request.referrer}'"
      else
        redirect_to :back
      end
    end

    def new_achievement
      if tutor_achievement.save
        flash[:success] = I18n.t(
          "views.tutor.recommendations.achievement_request.created"
        )
        redirect_to :back
      else
        render nothing: true,
          status: :unprocessable_entity
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

    def tutor_recommendation_params
      params.require(:tutor_recommendation).permit(
        { content_tutor_recommendations: [] },
        :tutor_achievement,
        { students: [] }
      )
    end

    def student_ids_params
      tutor_recommendation_params[:students]
    end

    def add_recommendation_to_client (students_ids, recommendation, content_ids)
      students_ids.each do |student_id|

        client_tutor_recommendation = ClientTutorRecommendation.find_by(
          client_id: student_id,
          tutor_recommendation: recommendation
        )

        unless client_tutor_recommendation.present?
          client_tutor_recommendation = create_new_recommendation(
            student_id,
            tutor_recommendation
          )
        end

        if client_tutor_recommendation.present?
          #validate if the contents have already been learned
          update_client_recommendation_status(
            student_id,
            client_tutor_recommendation,
            content_ids
          )
        end

      end
    end

    def create_new_recommendation(student_id, recommendation)
      new_recommendation = ClientTutorRecommendation.new(
        client_id: student_id,
        tutor_recommendation: recommendation,
        status: "in_progress"
      )
      if new_recommendation.save
        new_recommendation
      else
        nil
      end
    end

    def update_client_recommendation_status(student_id, recommendation, content_ids)
      client = User.find(student_id)
      TutorService::RecommendationsStatusUpdater.new(
        client,
        recommendation,
        content_ids
      ).perform
    end

    def iterate_and_assign_contents_to_recommendation(content_ids, students_ids)
      content_ids.each do |id|
        content = Content.find(id)
        content_tutor_recommendation = ContentTutorRecommendation.new(
          tutor_recommendation: tutor_recommendation,
          content: content
        )
        content_tutor_recommendation.save
      end
      add_recommendation_to_client(students_ids, tutor_recommendation, content_ids)
    end

    def format_student_names(students)
      students.map{|s| if s.name.present? then  s.name else s.username end }.join(', ')
    end

    def remove_blank(items)
      if items.present? then items.reject(&:blank?) else [] end
    end

    def create_tutor_recommendation(tutor_recommendation, content_ids, students_ids)
      if tutor_recommendation.save
        iterate_and_assign_contents_to_recommendation(content_ids, students_ids)
        names = format_student_names(students_selected)
        flash[:success] = I18n.t(
          "views.tutor.recommendations.recommendation_request.created",
          clients: names
        )
      else
        flash[:error] = I18n.t("views.tutor.common.error")
      end
    end

  end
end
