module Api
  class SocialSharingSerializer < ActiveModel::Serializer
    attributes :slug, :public_url

    def public_url
      public_sharing_url(
        id: slug,
        host: Rails.application.config.action_controller.asset_host
      )
    end
  end
end
