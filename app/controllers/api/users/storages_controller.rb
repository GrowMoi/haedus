module Api
  module Users
    class StoragesController < BaseController
      before_action :authenticate_user!

      respond_to :json

      api :PUT,
        "/users/storages",
        "update user data"
      param :frontendValues, String, required: true, desc: %{
      needs to be a JSON-encoded string having the following format:
        {
          "tree":{
            "advices": 1
            "vinetas": 1
          }
        }
      }

      def update
        storageData = JSON.parse(params[:frontendValues])
        if !storageData.empty?
          current_user.update_storage(storageData)
          render nothing: true,
                  status: :accepted
        else
          render nothing: true,
                  status: :unprocessable_entity
        end
      end

      api :GET,
          "/users/storages",
          "show user data"

      def show
        respond_with(storage: current_user.storage ? current_user.storage.frontendValues: {})
      end

    end
  end
end
