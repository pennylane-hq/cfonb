# frozen_string_literal: true

module CFONB
  module OperationDetails
    class LCS < Base
      ATTRIBUTES = %i[structured_label].freeze

      def self.apply(details, line)
        details.structured_label = line.detail[0..35].strip
      end

      CFONB::OperationDetails.register('LCS', self)
    end
  end
end
