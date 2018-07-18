module TreeService
  class RecommendedContentsFetcher
    COUNT = 4

    attr_reader :user, :neuron, :kind, :contents_pool

    def initialize(options)
      @contents_pool = []
      @user = options.fetch(:user)
      @kind = options.fetch(:kind)
      @neuron = options.fetch(:neuron)
      @remaining_levels = Content::LEVELS.dup
    end

    def contents
      fetch_pool!
      contents_pool
    end

    private

    def fetch_pool!
      return if contents_pool.any?

      unless user
        @contents_pool = contents_scope.limit(COUNT)
      else
        preferred_level = @remaining_levels.delete(preference.level)
        pool_contents!(
          level: preferred_level,
          count: COUNT
        )
      end
    end

    def pool_contents!(options = {})
      @contents_pool += contents_scope.where(
        level: options.fetch(:level)
      ).limit(
        options.fetch(:count)
      )
    end

    def contents_scope
      Neuron.approved_public_contents
             .where(
               neuron_id: neuron.children_or_parent_neurons.pluck(:id)
             )
    end

    def preference
      user.content_preferences.by_kind(kind)
    end
  end
end
