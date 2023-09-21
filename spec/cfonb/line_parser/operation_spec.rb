# frozen_string_literal: true

require 'cfonb'

describe CFONB::LineParser::Operation do
  describe '.initialize' do
    subject(:line) { described_class.new(input) }

    let(:input) do
      '0415589916201020EUR2 98765432100B115051964160519PRLV SEPA TEST CABINET           7654321UP0000000000322JXYZ123          '
    end

    it 'correctly parses a line' do
      expect(line).to have_attributes(
        'code' => '04',
        'bank' => '15589',
        'branch' => '01020',
        'currency' => 'EUR',
        'scale' => 2,
        'account' => '98765432100',
        'date' => Date.new(2019, 5, 15),
        'amount' => -32.21,
        'internal_operation_code' => '9162',
        'interbank_operation_code' => 'B1',
        'rejection_code' => '64',
        'value_date' => Date.new(2019, 5, 16),
        'label' => 'PRLV SEPA TEST CABINET',
        'number' => 7_654_321,
        'exoneration_code' => 'U',
        'unavailability_code' => 'P',
        'reference' => 'XYZ123'
      )
    end
  end
end
