# frozen_string_literal: true

module CFONB
  module OperationDetails
    class Unknown < Base
      ATTRIBUTES = %i[unknown].freeze

      def self.apply(details, line)
        details.unknown ||= {}
        code = line.detail_code.gsub(' ', '_')

        details.unknown[code] =
          if details.unknown[code] && line.detail.is_a?(String)
            details.unknown[code] + "\n#{line.detail}"
          else
            line.detail
          end
      end

      CFONB::OperationDetails.register('Unknown', self)
    end
  end
end
