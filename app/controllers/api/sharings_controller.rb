module Api
  class SharingsController < BaseController
    before_action :authenticate_user!

    respond_to :json

    api :POST,
        "/sharings",
        "create a sharing - for social networks"
    param :titulo, String, required: true
    param :descripcion, String, required: true
    param :uri, String, required: true
    param :imagen_url, String, desc: "will be used a default if no img is provided"
    def create
      sharing = current_user.social_sharings.create!(sharing_params)
      render json: sharing
    end

    private

    def sharing_params
      params.permit(
        :titulo,
        :descripcion,
        :uri,
        :imagen_url
      )
    end
  end
end
