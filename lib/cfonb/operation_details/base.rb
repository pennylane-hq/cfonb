# frozen_string_literal: true

module CFONB
  module OperationDetails
    class Base
      def self.inherited(base)
        base.singleton_class.prepend(
          Module.new do
            def apply(details, line)
              details.instance_variable_set(:"@#{line.detail_code}", line.detail)

              super
            end
          end,
        )
      end
    end
  end
end
