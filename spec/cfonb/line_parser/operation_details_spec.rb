# frozen_string_literal: true

require 'cfonb'

describe CFONB::LineParser::OperationDetails do
  describe '.initialize' do
    subject(:line) { described_class.new(input) }

    let(:input) do
      '0515589916201020EUR2 98765432100B1150519     LIBMENSUEAUHTR13133                                                        '
    end

    it 'correctly parses a line' do
      expect(line).to have_attributes(
        'code' => '05',
        'bank' => '15589',
        'branch' => '01020',
        'currency' => 'EUR',
        'scale' => 2,
        'account' => '98765432100',
        'date' => Date.new(2019, 5, 15),
        'internal_operation_code' => '9162',
        'interbank_operation_code' => 'B1',
        'detail_code' => 'LIB',
        'detail' => 'MENSUEAUHTR13133',
      )
    end
  end
end
