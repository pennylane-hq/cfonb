# frozen_string_literal: true

module CFONB
  module OperationDetail
    class LIB
      def self.apply(operation, line)
        operation.label += "\n#{line.detail.strip}"
      end

      CFONB::OperationDetail.register('LIB', self)
    end
  end
end
