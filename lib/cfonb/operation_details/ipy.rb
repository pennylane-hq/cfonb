# frozen_string_literal: true

module CFONB
  module OperationDetails
    class IPY < Base
      ATTRIBUTES = %i[debtor_identifier debtor_identifier_type].freeze

      def self.apply(operation, line)
        operation.debtor_identifier = line.detail[0..34].strip
        operation.debtor_identifier_type = line.detail[35..-1]&.strip
      end

      CFONB::OperationDetails.register('IPY', self)
    end
  end
end
