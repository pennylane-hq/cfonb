# frozen_string_literal: true

module CFONB
  module OperationDetail
    class LC2
      def self.apply(operation, line)
        operation.label += "\n#{line.detail.strip}"
      end

      CFONB::OperationDetail.register('LC2', self)
    end
  end
end
