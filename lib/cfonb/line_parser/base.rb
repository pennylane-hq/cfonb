# frozen_string_literal: true

require 'bigdecimal'

module CFONB
  module LineParser
    class Base
      using CFONB::Refinements::Strings

      BASE_DICTIONARY = [
        ['code', (0..1)].freeze,
        ['bank', (2..6)],
        ['branch', (11..15)],
        ['currency', (16..18)],
        ['scale', 19, proc { _1.to_i }],
        ['account', (21..31)],
        ['date', (34..39), proc { |value, instance| instance.send(:parse_date, value) }],
      ].freeze

      AMOUNT_SPECIFIERS = {
        'A' => { sign: 1, value: '1' },
        'B' => { sign: 1, value: '2' },
        'C' => { sign: 1, value: '3' },
        'D' => { sign: 1, value: '4' },
        'E' => { sign: 1, value: '5' },
        'F' => { sign: 1, value: '6' },
        'G' => { sign: 1, value: '7' },
        'H' => { sign: 1, value: '8' },
        'I' => { sign: 1, value: '9' },
        '{' => { sign: 1, value: '0' },
        'J' => { sign: -1, value: '1' },
        'K' => { sign: -1, value: '2' },
        'L' => { sign: -1, value: '3' },
        'M' => { sign: -1, value: '4' },
        'N' => { sign: -1, value: '5' },
        'O' => { sign: -1, value: '6' },
        'P' => { sign: -1, value: '7' },
        'Q' => { sign: -1, value: '8' },
        'R' => { sign: -1, value: '9' },
        '}' => { sign: -1, value: '0' },
      }.transform_values(&:freeze).freeze

      attr_reader :body, *BASE_DICTIONARY.map(&:first)

      def initialize(input)
        @body = input
        (BASE_DICTIONARY + self.class::DICTIONARY).each { parse_attribute(*_1) }
      end

      private

      def parse_attribute(attr, position, method = nil)
        input = body[position]&.strip
        value = method ? method.call(input, self) : input

        instance_variable_set(:"@#{attr}", value)
      end

      def parse_amount(input)
        specifier = AMOUNT_SPECIFIERS[input.last]
        raise ParserError.new("Invalid specifier '#{input.last}' for line #{input}") unless specifier

        specifier[:sign] * BigDecimal(input[0..-2] + specifier[:value]) / (10**scale)
      end

      def parse_date(input)
        # This won't work after 2060
        return if input.strip.empty?

        input_with_year = if input.last(2).to_i > 60
          "#{input[0..3]}19#{input[4..5]}"
        else
          "#{input[0..3]}20#{input[4..5]}"
        end

        Date.strptime(input_with_year, '%d%m%Y')
      rescue Date::Error
        raise ParserError.new("Invalid date '#{input}' for line #{input}")
      end
    end
  end
end
