# frozen_string_literal: true

module CFONB
  module OperationDetails
    class LIB < Base
      ATTRIBUTES = %i[free_label].freeze

      def self.apply(details, line)
        details.free_label = [details.free_label, line.detail.strip].compact.join("\n")
      end

      CFONB::OperationDetails.register('LIB', self)
    end
  end
end
