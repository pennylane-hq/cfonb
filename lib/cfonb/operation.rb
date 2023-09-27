# frozen_string_literal: true

module CFONB
  class Operation
    class AlreadyDefinedOperationError < StandardError; end
    class UnstartedOperationError < StandardError; end
    class UnhandledLineCodeError < StandardError; end

    BASE_ATTRIBUTES = %i[
      raw
      amount
      currency
      date
      exoneration_code
      interbank_code
      internal_code
      label
      number
      reference
      rejection_code
      unavailability_code
      value_date
    ].freeze

    attr_accessor(*BASE_ATTRIBUTES)

    def self.parse(input)
      current_operation = nil

      input.each_line do |line|
        (line.size / 120).times do |index|
          start = index * 120
          finish = start + 119

          line = CFONB120::LineParser.parse(line[start..finish])

          case line.code
          when '04'
            raise AlreadyDefinedOperationError if current_operation

            current_operation = new(line)
          when '05'
            raise UnstartedOperationError unless current_operation

            current_operation.merge_detail(line)
          else
            raise UnhandledLineCodeError
          end
        end
      end

      current_operation
    end

    def initialize(line)
      self.raw = line.body
      self.internal_code = line.internal_operation_code
      self.interbank_code = line.interbank_operation_code
      self.rejection_code = line.rejection_code
      self.exoneration_code = line.exoneration_code
      self.unavailability_code = line.unavailability_code
      self.currency = line.currency
      self.amount = line.amount
      self.date = line.date
      self.value_date = line.value_date
      self.label = line.label.strip
      self.number = line.number
      self.reference = line.reference
    end

    def merge_detail(line)
      self.raw += "\n#{line.body}"
      OperationDetail.for(line)&.apply(self, line)
    end

    def type_code
      "#{interbank_code}#{direction}"
    end

    private

    def direction
      amount.positive? ? 'C' : 'D'
    end
  end
end
