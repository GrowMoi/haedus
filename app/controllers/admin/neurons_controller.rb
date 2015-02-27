module Admin
  class NeuronsController < AdminController::Base
    include Breadcrumbs

    authorize_resource

    respond_to :html, :json

    expose(:neurons)
    expose(:neuron, attributes: :neuron_params)
    expose(:possible_parents) {
      # used by selects on forms
      scope = Neuron.select(:id, :title)
      unless neuron.new_record?
        scope = scope.where.not(id: neuron.id)
      end
      scope.map do |neuron|
        # format them for select
        [neuron.to_s, neuron.id]
      end
    }
    expose(:neuron_versions) {
      decorate sorted_neuron_versions
    }
    expose(:sorted_neuron_versions) {
      neuron.versions.merge(
        PaperTrail::Version.unscope(:order)
      ).order(id: :desc)
    }

    def index
      respond_to do |format|
        format.html
        format.json {
          render json: neurons, meta: {root_id: Neuron.first.id}
        }
      end
    end

    def new
      self.neuron.parent_id = params[:parent_id]
    end

    def create
      if neuron.save
        redirect_to(
          {action: :index},
          notice: I18n.t("views.neurons.created")
        )
      else
        render :new
      end
    end

    def update
      if neuron.save
        redirect_to admin_neurons_path, notice: I18n.t("views.neurons.updated")
      else
        render :edit
      end
    end

    private

    def neuron_params
      params.require(:neuron).permit :title,
                                      :parent_id
    end

    def resource
      @resource ||= neuron
    end

    def breadcrumb_for_log
      breadcrumb_for "show"
      add_breadcrumb(
        I18n.t("views.neurons.show_changelog"),
        log_admin_neuron_path(resource)
      )
    end
  end
end