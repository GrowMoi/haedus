module Api
  class UserTutorsController < BaseController
    before_action :authenticate_user!

    respond_to :json

    expose(:user_tutor) {
      scope = current_user.tutor_requests_received.pending
      scope.find params[:id]
    }

    api :POST,
        "/user_tutors/:id/respond",
        "respond (accept or reject) a **pending** tutor request"
    param :response, UserTutor::STATUSES, required: true
    def respond
      user_deleted = UserTutor.where(user_id: user_tutor.user_id,tutor_id: user_tutor.tutor_id, status: "deleted").first
      if user_deleted && params[:response] != "rejected"
        user_deleted.update_attributes(status: params[:response])
        user_tutor.destroy
      else
        user_tutor.update_attributes(status: params[:response])
        user_tutor.destroy if user_tutor.status == "rejected"
      end
      render json: UserTutorSerializer.new(user_tutor),
             status: :accepted
    end
  end
end
