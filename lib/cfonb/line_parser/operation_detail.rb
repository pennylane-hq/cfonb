# frozen_string_literal: true

module CFONB
  module LineParser
    class OperationDetail < Base
      DICTIONARY = [
        ['internal_operation_code', (7..10)],
        ['interbank_operation_code', (32..33)],
        ['detail_code', (45..47)],
        ['detail', (48..117)]
      ].freeze

      attr_reader(*DICTIONARY.map(&:first))

      CFONB::LineParser.register(CFONB::Parser::OPERATION_DETAIL_CODE, self)
    end
  end
end
