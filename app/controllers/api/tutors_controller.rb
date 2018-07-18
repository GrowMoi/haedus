module Api
  class TutorsController < BaseController
    before_action :authenticate_user!

    respond_to :json

    PAGE = 1
    PER_PAGE = 4

    expose(:my_recommendations) {
      ClientTutorRecommendation.where(client: current_user)
    }

    expose(:my_recommendations_in_progress) {
      my_recommendations.where(status: "in_progress").includes(:tutor_recommendation)
    }

    expose(:my_recommendations_reached) {
      my_recommendations.where(status: "reached").includes(:tutor_recommendation)
    }

    def recommendations
      if data_format == "contents"
        build_contents
      else
        build_recommendations
      end
    end

    def details

      render json: {
        details: {
          total_recommendations: my_recommendations.size,
          recommendations_in_progress: my_recommendations_in_progress.size,
          recommendations_reached: my_recommendations_reached.size,
          recommendation_contents_pending: recommended_contents.size

        }
      },
      status: :accepted
    end

    private

    def build_contents
      serialized_contents = ActiveModel::ArraySerializer.new(
        recommended_contents,
        scope: current_user,
        each_serializer: Api::ContentSerializer
      )
      contents = paginate_array(serialized_contents)
      resp = {
        contents: contents
      }
      send_response(contents, resp)
    end

    def build_recommendations
      serialized_recommendations = ActiveModel::ArraySerializer.new(
        my_recommendations,
        scope: current_user,
        each_serializer: Api::TutorRecommendationSerializer
      )
      recommendations = paginate_array(serialized_recommendations)

      resp = {
        recommendations: recommendations,
        meta: {
          total_in_progress: my_recommendations_in_progress.count,
          total_reached: my_recommendations_reached.count
        }
      }

      send_response(recommendations, resp)
    end

    def send_response(data, resp)
      resp[:meta] = resp[:meta] || {}
      resp[:meta][:total_items] = data.total_count
      resp[:meta][:total_pages] = data.total_pages
      render json: resp,
      status: :accepted
    end

    def recommended_contents
      user_contents = []
      my_recommendations_in_progress.find_each do |r|
        array_contents = ContentTutorRecommendation.includes(:content)
                                                   .where(tutor_recommendation: r.tutor_recommendation)
                                                   .map(&:content)
        user_contents.concat array_contents
      end
      user_contents.uniq.delete_if{|e|current_user.already_learnt?(e) || current_user.already_read?(e)}.reverse
    end

    def paginate_array(items)
      array_items = JSON.parse(items.to_json)
      Kaminari.paginate_array(array_items)
              .page(params[:page] || PAGE)
              .per(params[:per_page] || PER_PAGE)

    end

    def data_format
      default_format = "recommendations"
      if params[:data_format] == "contents"
        "contents"
      else
        default_format
      end
    end

  end
end
