module Api
  class TutorPlansController < BaseController

    expose(:plans) {
      Product.where(category: 'payments_website')
    }

    respond_to :json

    api :GET,
        "/tutor_plans",
        "returns tutor plans"
    def index
      respond_with(
        plans,
        each_serializer: Api::PlanSerializer
      )
    end
  end
end
