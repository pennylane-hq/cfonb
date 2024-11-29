# frozen_string_literal: true

require 'bigdecimal'

module CFONB
  module OperationDetails
    class MMO < Base
      ATTRIBUTES = %i[original_currency original_amount exchange_rate].freeze

      def self.apply(details, line)
        details.original_currency = line.detail[0..2]
        scale = line.detail[3].to_i

        details.original_amount = BigDecimal(line.detail[4..17]) / (10**scale)
        exchange_rate_value = line.detail[26..29]

        return if exchange_rate_value.nil? || exchange_rate_value.strip.empty?

        exchange_rate_scale = line.detail[18]
        details.exchange_rate = BigDecimal(exchange_rate_value) / (10**BigDecimal(exchange_rate_scale))
      end

      CFONB::OperationDetails.register('MMO', self)
    end
  end
end
