module Admin
  class ContentImportingsController < AdminController::Base
    include Breadcrumbs

    before_action :add_breadcrumbs

    authorize_resource

    expose(:resource) {
      ContentImporting.find(params[:id])
    }

    def index
      @content_importings = ContentImporting.order(id: :desc).includes(:user)
    end

    def new
      @content_importing = ContentImporting.new
    end

    def show
      @decorated_resource = decorate(resource)
    end

    def create
      @content_importing = ContentImporting.new(content_importing_params)
      @content_importing.user = current_user
      if @content_importing.save
        redirect_to(
          { action: :index },
          notice: I18n.t("views.content_importings.created")
        )
      else
        render :new
      end
    end

    private

    def content_importing_params
      params.require(:content_importing).permit(:file)
    end

    def nav_item
      :neurons
    end
  end
end
