# frozen_string_literal: true

module CFONB
  module OperationDetails
    class Base
      def self.inherited(base)
        base.singleton_class.prepend(
          Module.new do
            def apply(details, line)
              code = :"@#{line.detail_code}"
              details.instance_variable_set(code, instance_value(details, line, code))

              super
            end

            private

            def append_detail?(details, line, code)
              details.instance_variable_defined?(code) && line.detail.is_a?(String)
            end

            def instance_value(details, line, code)
              return line.detail unless append_detail?(details, line, code)

              details.instance_variable_get(code) + "\n#{line.detail}"
            end
          end,
        )
      end
    end
  end
end
