# frozen_string_literal: true

module CFONB
  module OperationDetails
    class LC2 < Base
      def self.apply(operation, line)
        operation.label += "\n#{line.detail.strip}"
      end

      CFONB::OperationDetails.register('LC2', self)
    end
  end
end
