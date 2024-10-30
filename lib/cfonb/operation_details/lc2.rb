# frozen_string_literal: true

module CFONB
  module OperationDetails
    class LC2 < Base
      def self.apply(operation, line)
        operation.unstructured_label_2 = if operation.unstructured_label_2.nil?
          line.detail.strip.to_s
        else
          "#{operation.unstructured_label_2}\n#{line.detail.strip}"
        end
      end

      CFONB::OperationDetails.register('LC2', self)
    end
  end
end
