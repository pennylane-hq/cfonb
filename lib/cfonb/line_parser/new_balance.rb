# frozen_string_literal: true

module CFONB
  module LineParser
    class NewBalance < Base
      DICTIONARY = [
        ['amount', (90..103), proc { |value, instance| instance.send(:parse_amount, value) }],
      ].freeze

      attr_reader(*DICTIONARY.map(&:first))

      CFONB::LineParser.register(CFONB::Parser::NEW_BALANCE_CODE, self)
    end
  end
end
