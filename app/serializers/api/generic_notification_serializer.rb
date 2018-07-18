module Api
  class GenericNotificationSerializer < ActiveModel::Serializer
    attributes :id,
        :title,
        :description,
        :user_id,
        :videos,
        :media,
        :type,
        :tutor,
        :created_at

    def videos
      video_urls = object.notification_videos.map {|v| v[:url] }
      video_urls.compact
    end

    def media
      media_urls = object.notification_medium.map(&:media_url)
      media_urls.compact
    end

    def created_at
      object.created_at
    end

    def type
      object.data_type || 'generic'
    end

    def tutor
      TutorSerializer.new(object.user, root: false)
    end
  end
end
