# frozen_string_literal: true

module CFONB
  module OperationDetail
    class NBU
      ATTRIBUTES = %i[ultimate_creditor].freeze

      def self.apply(operation, line)
        operation.ultimate_creditor = line.detail.strip
      end

      CFONB::OperationDetail.register('NBU', self)
    end
  end
end
