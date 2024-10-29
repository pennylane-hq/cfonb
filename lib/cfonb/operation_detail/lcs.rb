# frozen_string_literal: true

module CFONB
  module OperationDetail
    class LCS
      ATTRIBUTES = %i[structured_label].freeze

      def self.apply(operation, line)
        formatted_label = line.detail[0..35].strip

        operation.structured_label = if operation.structured_label.nil?
          formatted_label.to_s
        else
          "#{operation.structured_label}\n#{formatted_label}"
        end
      end

      CFONB::OperationDetail.register('LCS', self)
    end
  end
end
