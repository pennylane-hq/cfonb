# frozen_string_literal: true

module CFONB
  module OperationDetails
    class LCC < Base
      def self.apply(operation, line)
        operation.label += "\n#{line.detail.strip}"
      end

      CFONB::OperationDetails.register('LCC', self)
    end
  end
end
