# frozen_string_literal: true

module CFONB
  module OperationDetails
    class LCC < Base
      ATTRIBUTES = %i[unstructured_label].freeze

      def self.apply(operation, line)
        operation.unstructured_label = if operation.unstructured_label.nil?
          line.detail.strip.to_s
        else
          "#{operation.unstructured_label}\n#{line.detail.strip}"
        end
      end

      CFONB::OperationDetails.register('LCC', self)
    end
  end
end
