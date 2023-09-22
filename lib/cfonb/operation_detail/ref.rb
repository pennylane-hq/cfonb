# frozen_string_literal: true

module CFONB
  module OperationDetail
    class REF
      ATTRIBUTES = %i[reference].freeze

      def self.apply(operation, line)
        operation.reference = [
          operation.reference,
          line.detail.strip
        ].compact.join(' - ')
      end

      CFONB::OperationDetail.register('REF', self)
    end
  end
end
