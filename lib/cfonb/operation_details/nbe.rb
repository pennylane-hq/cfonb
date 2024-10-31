# frozen_string_literal: true

module CFONB
  module OperationDetails
    class NBE < Base
      ATTRIBUTES = %i[creditor].freeze

      def self.apply(details, line)
        details.creditor = line.detail.strip
      end

      CFONB::OperationDetails.register('NBE', self)
    end
  end
end
