# frozen_string_literal: true

module CFONB
  module OperationDetails
    class LIB < Base
      ATTRIBUTES = %i[free_label].freeze

      def self.apply(operation, line)
        operation.free_label = if operation.free_label.nil?
          line.detail.strip.to_s
        else
          "#{operation.free_label}\n#{line.detail.strip}"
        end
      end

      CFONB::OperationDetails.register('LIB', self)
    end
  end
end
