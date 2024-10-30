# frozen_string_literal: true

module CFONB
  module OperationDetails
    class LC2 < Base
      ATTRIBUTES = %i[unstructured_label_2].freeze

      def self.apply(details, line)
        details.unstructured_label_2 = line.detail.strip
      end

      CFONB::OperationDetails.register('LC2', self)
    end
  end
end
