module TutorService
  class RecommendationsStatusUpdater
    def initialize(client, client_tutor_recommendation, content_ids = [])
      @client = client
      @client_tutor_recommendation = client_tutor_recommendation
      @content_ids = content_ids.map(&:to_i).uniq
    end

    def perform
      client_content_learnings = ContentLearning.where(user: @client, content_id: @content_ids)
      client_content_learnings = client_content_learnings.map(&:content_id).uniq
      recomendation_reached = nil
      is_reached = validate_recomendation_reached(client_content_learnings, @content_ids)
      if is_reached && @client_tutor_recommendation.status == "in_progress"
        @client_tutor_recommendation.status = "reached"
        @client_tutor_recommendation.save
        recomendation_reached = @client_tutor_recommendation
      end
      recomendation_reached
    end

    private

    def validate_recomendation_reached(content_learned, content_ids)
      (content_ids & content_learned).sort == content_ids.sort
    end

  end
end
