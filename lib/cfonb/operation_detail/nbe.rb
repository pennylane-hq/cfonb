# frozen_string_literal: true

module CFONB
  module OperationDetail
    class NBE
      ATTRIBUTES = %i[creditor].freeze

      def self.apply(operation, line)
        operation.creditor = line.detail.strip
      end

      CFONB::OperationDetail.register('NBE', self)
    end
  end
end
