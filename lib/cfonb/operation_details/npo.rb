# frozen_string_literal: true

module CFONB
  module OperationDetails
    class NPO < Base
      ATTRIBUTES = %i[ultimate_debtor].freeze

      def self.apply(details, line)
        details.ultimate_debtor = line.detail.strip
      end

      CFONB::OperationDetails.register('NPO', self)
    end
  end
end
