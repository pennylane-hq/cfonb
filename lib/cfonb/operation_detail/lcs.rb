# frozen_string_literal: true

module CFONB
  module OperationDetail
    class LCS
      def self.apply(operation, line)
        operation.label += "\n#{line.detail[0..35].strip}"
      end

      CFONB::OperationDetail.register('LCS', self)
    end
  end
end
