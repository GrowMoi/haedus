module Tutor
  class SimpleContentSerializer < ActiveModel::Serializer

    attributes :id,
        :kind,
        :description,
        :neuron_id,
        :source,
        :title
  end
end
