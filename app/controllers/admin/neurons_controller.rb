module Admin
  class NeuronsController < Neurons::BaseController
    before_action :add_breadcrumbs
    before_action :build_relationships_for_formatted_contents!,
                  only: [:new, :edit]

    authorize_resource

    expose(:neurons) {
      if current_user.admin?
        scope = Neuron.all
      else
        scope = Neuron.not_deleted
      end
      scope.includes(contents: :possible_answers)
    }

    expose(:possible_parents) {
      # used by selects on forms
      scope = Neuron.select(:id, :title).order(:title)
      unless neuron.new_record?
        scope = scope.where.not(id: neuron.id)
      end
      scope.map do |neuron|
        # format them for select
        [neuron.to_s, neuron.id]
      end
    }

    expose(:search_engines) {
      SearchEngine.active
    }

    expose(:initial_neurons) {
      TreeService::DepthFetcher.new(
        depth: 2
      ).neurons
    }

    expose(:root_neuron) {
      TreeService::RootFetcher.root_neuron
    }

    def index
      respond_to do |format|
        format.html
        format.json {
          render json: neurons, meta: {
            root_id: root_neuron.id,
            initial_tree: initial_neurons.map(&:id)
          }
        }
      end
    end

    def new
      neuron.parent_id = params[:parent_id]
    end

    def show
      neuron.eager_contents!
    end

    def create
      if neuron.save_with_version
        redirect_to(
          {action: :show, id: neuron.id},
          notice: I18n.t("views.neurons.created")
        )
      else
        render :new
      end
    end

    def update
      if neuron.save_with_version
        redirect_to(
          {action: :show, id: neuron.id},
          notice: I18n.t("views.neurons.updated")
        )
      else
        render :edit
      end
    end

    def delete
      neuron.paper_trail_event = "delete"
      if neuron.update(deleted: true)
        redirect_to(
          {action: :index},
          notice: I18n.t("views.neurons.delete")
        )
      else
        redirect_to(
          {action: :index},
          error: I18n.t("activerecord.errors.messages.cannot_delete_neuron",
                  neuron: neuron)
        )
      end
    end

    def restore
      neuron.paper_trail_event = "restore"
      neuron.update! deleted: false
      redirect_to(
        {action: :index},
        notice: I18n.t("views.neurons.restore")
      )
    end

    private

    def build_relationships_for_formatted_contents!
      formatted_contents.each do |level, level_contents|
        level_contents.each do |kind, contents|
          contents.each do |decorated_content|
            decorated_content.build_one_link!
            decorated_content.build_one_video!
          end
        end
      end
    end
  end
end
