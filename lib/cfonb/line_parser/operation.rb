# frozen_string_literal: true

module CFONB
  module LineParser
    class Operation < Base
      DICTIONARY = [
        ['internal_operation_code', (7..10)],
        ['interbank_operation_code', (32..33)],
        ['rejection_code', (40..41)],
        ['value_date', (42..47), proc { |value, instance| instance.send(:parse_date, value) }],
        ['label', (48..79)],
        ['number', (81..87), proc { _1.to_i }],
        ['exoneration_code', 88],
        ['unavailability_code', 89],
        ['reference', (104..119)],
        ['amount', (90..103), proc { |value, instance| instance.send(:parse_amount, value) }]
      ].freeze

      attr_reader(*DICTIONARY.map(&:first))

      CFONB::LineParser.register(CFONB::Parser::OPERATION_CODE, self)
    end
  end
end
