# frozen_string_literal: true

module CFONB
  module OperationDetail
    class RCN
      ATTRIBUTES = %i[reference purpose].freeze

      def self.apply(operation, line)
        operation.reference = [
          operation.reference,
          line.detail[0..34].strip
        ].compact.join(' - ')

        operation.purpose = line.detail[35..-1]&.strip
      end

      CFONB::OperationDetail.register('RCN', self)
    end
  end
end
