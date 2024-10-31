# frozen_string_literal: true

module CFONB
  class Operation
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
      details
    ].freeze

    attr_accessor(*BASE_ATTRIBUTES)

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
      self.details = Details.new(line.reference)
    end

    def merge_detail(line)
      self.raw += "\n#{line.body}"

      OperationDetails.for(line)&.apply(details, line)
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
