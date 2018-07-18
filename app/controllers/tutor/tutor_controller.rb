module Tutor
  module TutorController
    class Base < ::ApplicationController
      layout "tutor"

      before_action :authenticate_user!
      before_action :restrict_cliente!

      private

      def restrict_cliente!
        redirect_to(
          root_path,
          error: I18n.t("views.unauthorized")
        ) if current_user.cliente?
      end
    end
  end
end
