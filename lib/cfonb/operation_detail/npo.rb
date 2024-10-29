# frozen_string_literal: true

module CFONB
  module OperationDetail
    class NPO
      ATTRIBUTES = %i[ultimate_debtor].freeze

      def self.apply(operation, line)
        operation.ultimate_debtor = line.detail.strip
      end

      CFONB::OperationDetail.register('NPO', self)
    end
  end
end
