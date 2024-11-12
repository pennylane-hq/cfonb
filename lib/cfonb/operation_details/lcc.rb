# frozen_string_literal: true

module CFONB
  module OperationDetails
    class LCC < Base
      ATTRIBUTES = %i[unstructured_label].freeze

      def self.apply(details, line)
        details.unstructured_label = line.detail.strip.to_s
      end

      CFONB::OperationDetails.register('LCC', self)
    end
  end
end
