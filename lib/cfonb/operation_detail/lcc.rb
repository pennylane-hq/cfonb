# frozen_string_literal: true

module CFONB
  module OperationDetail
    class LCC
      def self.apply(operation, line)
        operation.label += "\n#{line.detail.strip}"
      end

      CFONB::OperationDetail.register('LCC', self)
    end
  end
end
