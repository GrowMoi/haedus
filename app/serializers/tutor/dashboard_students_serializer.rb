module Tutor
  class DashboardStudentsSerializer < ActiveModel::Serializer

    attributes :id,
        :name,
        :username,
        :status,
        :created_at

    def status
      tutor_request = scope.tutor_requests_sent.not_deleted.find_by(user_id: object.id)
      tutor_request.status
    end
  end
end
