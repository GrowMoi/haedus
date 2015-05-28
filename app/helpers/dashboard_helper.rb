module DashboardHelper
  ##
  # Creates a switcher for different neuron states
  # picks states from Neuron model
  #
  # @return [String] tabs for neuron states
  def neuron_switcher
    states = Neuron.states.keys
    content_tag :div, class: "btn-group" do
      states.map do |state|
        active = "active" if neurons_state == state
        link_to t("views.neurons.#{state}"),
                admin_root_path(state: state),
                class: "btn btn-default #{active}"
      end.join.html_safe
    end
  end
end