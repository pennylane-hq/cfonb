# frozen_string_literal: true

module CFONB
  module OperationDetails
    class LIB < Base
      def self.apply(operation, line)
        operation.label += "\n#{line.detail.strip}"
      end

      CFONB::OperationDetails.register('LIB', self)
    end
  end
end
