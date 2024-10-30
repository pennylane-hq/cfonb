# frozen_string_literal: true

module CFONB
  module OperationDetails
    class REF < Base
      using CFONB::Refinements::Strings

      ATTRIBUTES = %i[reference].freeze

      def self.apply(operation, line)
        operation.reference = [
          operation.reference,
          line.detail.strip,
        ].filter_map(&:presence).join(' - ')
      end

      CFONB::OperationDetails.register('REF', self)
    end
  end
end
