# frozen_string_literal: true

module CFONB
  module OperationDetail
    @details = {}

    def self.register(code, klass)
      if klass.const_defined?(:ATTRIBUTES)
        Operation.class_eval do
          attr_accessor(*klass::ATTRIBUTES)
        end
      end

      @details[code] = klass
    end

    def self.for(line)
      @details[line.detail_code]
    end
  end
end
