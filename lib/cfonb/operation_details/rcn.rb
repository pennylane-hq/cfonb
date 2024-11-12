# frozen_string_literal: true

module CFONB
  module OperationDetails
    class RCN < Base
      using CFONB::Refinements::Strings

      ATTRIBUTES = %i[client_reference purpose].freeze

      def self.apply(details, line)
        details.client_reference = line.detail[0..34].strip
        details.purpose = line.detail[35..-1]&.strip
      end

      CFONB::OperationDetails.register('RCN', self)
    end
  end
end
