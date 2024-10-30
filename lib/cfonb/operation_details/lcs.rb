# frozen_string_literal: true

module CFONB
  module OperationDetails
    class LCS < Base
      def self.apply(operation, line)
        operation.label += "\n#{line.detail[0..35].strip}"
      end

      CFONB::OperationDetails.register('LCS', self)
    end
  end
end
