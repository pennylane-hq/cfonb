# frozen_string_literal: true

module CFONB
  module OperationDetails
    class RCN < Base
      using CFONB::Refinements::Strings

      ATTRIBUTES = %i[reference purpose].freeze

      def self.apply(details, line)
        details.reference = [
          details.reference,
          line.detail[0..34].strip,
        ].filter_map(&:presence).join(' - ')

        details.purpose = line.detail[35..-1]&.strip
      end

      CFONB::OperationDetails.register('RCN', self)
    end
  end
end
