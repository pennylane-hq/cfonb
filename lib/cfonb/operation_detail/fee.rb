# frozen_string_literal: true

module CFONB
  module OperationDetail
    class FEE
      ATTRIBUTES = %i[fee fee_currency].freeze

      def self.apply(operation, line)
        operation.fee_currency = line.detail[0..2]
        scale = line.detail[3].to_i

        operation.fee = BigDecimal(line.detail[4..17]) / (10**scale)
      end

      CFONB::OperationDetail.register('FEE', self)
    end
  end
end
