module Tutor
  class ClientController < TutorController::Base
    expose(:client_data) {
      User.where(id: params[:client_id], role: :cliente)
    }

    def get_client_statistics
      client = client_data.first
      statistics = client.generate_statistics(
        [
          "total_neurons_learnt",
          "total_content_readings",
          "total_right_questions"
        ]
      )
      render json: {
        data: statistics,
        meta: {
          client: {
            username: client.username,
            tree_image: client.tree_image.url
          }
        }
      }
    end

    def index
      render
    end

  end
end
