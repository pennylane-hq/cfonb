# frozen_string_literal: true

module CFONB
  module OperationDetails
    class FEE < Base
      ATTRIBUTES = %i[fee fee_currency].freeze

      def self.apply(details, line)
        details.fee_currency = line.detail[0..2]
        scale = line.detail[3].to_i

        details.fee = BigDecimal(line.detail[4..17]) / (10**scale)
      end

      CFONB::OperationDetails.register('FEE', self)
    end
  end
end
