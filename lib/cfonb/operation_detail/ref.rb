# frozen_string_literal: true

module CFONB
  module OperationDetail
    class REF
      using CFONB::Refinements::Strings

      ATTRIBUTES = %i[reference].freeze

      def self.apply(operation, line)
        operation.reference = [
          operation.reference,
          line.detail.strip
        ].filter_map(&:presence).join(' - ')
      end

      CFONB::OperationDetail.register('REF', self)
    end
  end
end
