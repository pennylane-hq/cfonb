# frozen_string_literal: true

module CFONB
  module OperationDetail
    class RCN
      using CFONB::Refinements::Strings

      ATTRIBUTES = %i[reference purpose].freeze

      def self.apply(operation, line)
        operation.reference = [
          operation.reference,
          line.detail[0..34].strip,
        ].filter_map(&:presence).join(' - ')

        operation.purpose = line.detail[35..-1]&.strip
      end

      CFONB::OperationDetail.register('RCN', self)
    end
  end
end
