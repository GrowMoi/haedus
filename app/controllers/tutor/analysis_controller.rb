module Tutor
  class AnalysisController < TutorController::Base
    include ApplicationHelper
    expose(:client_data) {
      User.where(id: params[:client_id], role: :cliente)
    }
    expose(:content_reading_times) {
      client_data.first.content_reading_times
    }
    expose(:reading_time_content_ids) {
      content_reading_times.select(:content_id)
                           .group(:content_id)
                           .pluck(:content_id)
    }
    expose(:grouped_reading_time_content_ids) {
      grouped = []
      ids_copy = reading_time_content_ids.dup
      while ids_copy.count > 0
        groups_of = 2 # in groups of 2 for the grid
        grouped.push ids_copy.slice!(0, groups_of)
      end
      grouped
    }

    def index
      if params[:search]
        @clients =  UserClientSearch.new(q:params[:search]).results
      else
        @clients = User.where(:role => :cliente)
      end
    end

    def get_user_analysis

      result = grouped_reading_time_content_ids.map do |content_ids|
        content_data_array = []
        content_ids.each do |id|
          time = reading_time_for_content(id)
          content_data_array.push({
            content_id: id,
            title: show_content_title(id),
            time: time,
            time_humanized: humanize_ms(time)
          })
        end
        content_data_array
      end

      client = client_data.first

      render json: {
        data: {
          grouped_reading_time: result || [],
          statistics: client.generate_statistics(
            [
              "total_neurons_learnt",
              "total_content_readings",
              "total_right_questions",
              "total_notes",
              "images_opened_in_count",
              "user_sign_in_count",
              "used_time",
              "content_readings_by_branch"
            ]
          )
        },
        meta: {
          client: {
            username: client.username
          }
        }
      }
    end

    private

    def reading_time_for_content(content_id)
      content_reading_times.where(
        content_id: content_id
      ).sum(:time)
    end

    def show_content_title(id)
      title = Content.find(id).title
      title.humanize
    end

    helper_method :reading_time_for_content
    helper_method :show_content_title
  end
end
