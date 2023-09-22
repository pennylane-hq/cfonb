# frozen_string_literal: true

require 'cfonb'

describe CFONB::Statement do
  subject(:statement) do
    described_class.new(begin_line)
                   .tap { _1.operations << operation }
                   .tap { _1.merge_new_balance(end_line) }
  end

  let(:operation) do
    CFONB::Operation
      .new(operation_line)
      .tap { _1.merge_detail(detail_line) }
  end

  let(:begin_line) do
    CFONB::LineParser.parse(
      '0115589    00000EUR2 98765432100  150519                                                  0000000001904}150519160519    '
    )
  end
  let(:operation_line) do
    CFONB::LineParser.parse(
      '0415589916200000EUR2 98765432100B1160519  160519PRLV SEPA TEST CABINET           0000000000000000000322J                '
    )
  end
  let(:detail_line) do
    CFONB::LineParser.parse(
      '0515589916200000EUR2 98765432100B1160519     LIBMENSUEAUHTR13133                                                        '
    )
  end
  let(:end_line) do
    CFONB::LineParser.parse(
      '0715489    00000EUR2 98765432100  160519                                                  0000000002412J                '
    )
  end

  describe '#raw' do
    it 'joins all the statement raws' do
      expect(statement.raw).to eq(<<~TXT.chomp)
        0115589    00000EUR2 98765432100  150519                                                  0000000001904}150519160519#{'    '}
        0415589916200000EUR2 98765432100B1160519  160519PRLV SEPA TEST CABINET           0000000000000000000322J#{'                '}
        0515589916200000EUR2 98765432100B1160519     LIBMENSUEAUHTR13133#{'                                                        '}
        0715489    00000EUR2 98765432100  160519                                                  0000000002412J#{'                '}
      TXT
    end
  end

  describe '#rib' do
    it 'returns the correct rib' do
      expect(statement.rib).to eq('15589000009876543210088')
    end
  end

  describe '#iban' do
    it 'returns the correct iban' do
      expect(statement.iban).to eq('FR7615589000009876543210088')
    end
  end
end
