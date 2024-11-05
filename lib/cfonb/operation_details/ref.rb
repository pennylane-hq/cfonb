# frozen_string_literal: true

module CFONB
  module OperationDetails
    class REF < Base
      using CFONB::Refinements::Strings

      ATTRIBUTES = %i[operation_reference].freeze

      def self.apply(details, line)
        details.operation_reference = line.detail.strip
      end

      CFONB::OperationDetails.register('REF', self)
    end
  end
end
