# frozen_string_literal: true

module CFONB
  module OperationDetails
    class NPY < Base
      ATTRIBUTES = %i[debtor].freeze

      def self.apply(operation, line)
        operation.debtor = line.detail.strip
      end

      CFONB::OperationDetails.register('NPY', self)
    end
  end
end
