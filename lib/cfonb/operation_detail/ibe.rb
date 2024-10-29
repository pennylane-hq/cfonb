# frozen_string_literal: true

module CFONB
  module OperationDetail
    class IBE
      ATTRIBUTES = %i[creditor_identifier creditor_identifier_type].freeze

      def self.apply(operation, line)
        operation.creditor_identifier = line.detail[0..34].strip
        operation.creditor_identifier_type = line.detail[35..-1].strip
      end

      CFONB::OperationDetail.register('IBE', self)
    end
  end
end
