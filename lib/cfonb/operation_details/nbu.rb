# frozen_string_literal: true

module CFONB
  module OperationDetails
    class NBU < Base
      ATTRIBUTES = %i[ultimate_creditor].freeze

      def self.apply(details, line)
        details.ultimate_creditor = line.detail.strip
      end

      CFONB::OperationDetails.register('NBU', self)
    end
  end
end
