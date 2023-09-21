# frozen_string_literal: true

module CFONB
  module LineParser
    using CFONB::Refinements::Strings

    @parsers = {}

    def self.register(code, klass)
      @parsers[code] = klass
    end

    def self.for(code)
      @parsers[code]
    end

    def self.parse(input)
      self.for(input.first(2)).new(input)
    end
  end
end
