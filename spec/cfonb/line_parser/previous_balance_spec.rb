# frozen_string_literal: true

require 'cfonb'

describe CFONB::LineParser::PreviousBalance do
  describe '.initialize' do
    subject(:line) { described_class.new(input) }

    let(:input) do
      '0115589    01020EUR2 98765432100  150519                                                  0000000001904L150519160519    '
    end

    it 'correctly parses a line' do
      expect(line).to have_attributes(
        'code' => '01',
        'bank' => '15589',
        'branch' => '01020',
        'currency' => 'EUR',
        'scale' => 2,
        'account' => '98765432100',
        'date' => Date.new(2019, 5, 15),
        'amount' => -190.43,
      )
    end
  end
end
