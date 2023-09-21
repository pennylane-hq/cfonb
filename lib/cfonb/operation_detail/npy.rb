# frozen_string_literal: true

module CFONB
  module OperationDetail
    class NPY
      ATTRIBUTES = %i[debtor].freeze

      def self.apply(operation, line)
        operation.debtor = line.detail.strip
      end

      CFONB::OperationDetail.register('NPY', self)
    end
  end
end
