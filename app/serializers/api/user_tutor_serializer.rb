module Api
  class UserTutorSerializer < ActiveModel::Serializer
    attributes  :id,
                :status,
                :tutor,
                :type,
                :created_at

    def tutor
      object.tutor # UserSerializer.new(object.tutor)
                   # (or would be better to use custom
                   # TutorSerializer)
    end

    def created_at
      object.created_at
    end

    def type
      'tutor_request'
    end
  end
end
