# frozen_string_literal: true

require 'cfonb'
require 'ostruct'

describe CFONB::Operation do
  subject(:operation) { described_class.new(line) }

  let(:line) do
    OpenStruct.new(
      body: 'xxxxxxxxxxxxxx',
      label: 'A random operation label',
      date: Date.new(2021, 3, 5),
      currency: 'EUR',
      amount: -15,
      reference: '42',
    )
  end

  describe '#merge_detail' do
    it 'merges the lines body' do
      detail = OpenStruct.new(body: 'yyyyyyyyyyyyyy')
      operation.merge_detail(detail)

      expect(operation.raw).to eq(<<~TXT.strip)
        xxxxxxxxxxxxxx
        yyyyyyyyyyyyyy
      TXT
    end

    context 'with a LIB detail' do
      let(:detail) { OpenStruct.new(body: '', detail_code: 'LIB', detail: '   Extra label   ') }

      it 'Adds the new label line' do
        operation.merge_detail(detail)

        expect(operation.label).to eq(<<~TXT.strip)
          A random operation label
          Extra label
        TXT
      end
    end

    context 'with a LCC detail' do
      let(:detail) { OpenStruct.new(body: '', detail_code: 'LCC', detail: '   Extra label   ') }

      it 'Adds the new label line' do
        operation.merge_detail(detail)

        expect(operation.label).to eq(<<~TXT.strip)
          A random operation label
          Extra label
        TXT
      end
    end

    context 'with a LC2 detail' do
      let(:detail) { OpenStruct.new(body: '', detail_code: 'LC2', detail: '   Extra label   ') }

      it 'Adds the new label line' do
        operation.merge_detail(detail)

        expect(operation.label).to eq(<<~TXT.strip)
          A random operation label
          Extra label
        TXT
      end
    end

    context 'with a LCS detail' do
      let(:detail) { OpenStruct.new(body: '', detail_code: 'LCS', detail: '   Extra label   ') }

      it 'Adds the new label line' do
        operation.merge_detail(detail)

        expect(operation.label).to eq(<<~TXT.strip)
          A random operation label
          Extra label
        TXT
      end
    end

    context 'with a MMO detail' do
      let(:detail) { OpenStruct.new(body: '', detail_code: 'MMO', detail: 'USD200000000001234') }

      it 'Adds the original currency information' do
        operation.merge_detail(detail)

        expect(operation).to have_attributes(
          original_currency: 'USD',
          original_amount: -12.34,
          exchange_rate: nil,
        )
      end

      context 'with exchange rate' do
        let(:detail) { OpenStruct.new(body: '', detail_code: 'MMO', detail: 'USD000000000008358300000001077') }

        it 'Adds the original currency information' do
          operation.merge_detail(detail)

          expect(operation).to have_attributes(
            original_currency: 'USD',
            original_amount: -8358,
            exchange_rate: 1.077,
          )
        end
      end

      context 'when exchange rate is missing' do
        let(:detail) { OpenStruct.new(body: '', detail_code: 'MMO', detail: 'EUR200000001875625             04') }

        it 'Adds the original currency information' do
          operation.merge_detail(detail)

          expect(operation).to have_attributes(
            original_currency: 'EUR',
            original_amount: -18_756.25,
            exchange_rate: nil,
          )
        end
      end
    end

    context 'with a NPY detail' do
      let(:detail) { OpenStruct.new(body: '', detail_code: 'NPY', detail: 'Patrick') }

      it 'Adds the debtor information' do
        operation.merge_detail(detail)

        expect(operation).to have_attributes(debtor: 'Patrick')
      end
    end

    context 'with a NBE detail' do
      let(:detail) { OpenStruct.new(body: '', detail_code: 'NBE', detail: 'Jean-Pierre') }

      it 'Adds the creditor information' do
        operation.merge_detail(detail)

        expect(operation).to have_attributes(creditor: 'Jean-Pierre')
      end
    end

    context 'with a RCN detail' do
      let(:detail) do
        OpenStruct.new(
          body: '',
          detail_code: 'RCN',
          detail: 'SWILE-CMD-TR-YPDHMA                TICKET RESTO                       ',
        )
      end

      it 'adds the reference information' do
        operation.merge_detail(detail)

        expect(operation.reference).to eq('42 - SWILE-CMD-TR-YPDHMA')
        expect(operation.purpose).to eq('TICKET RESTO')
      end
    end

    context 'with a REF detail' do
      let(:detail) do
        OpenStruct.new(
          body: '0530002112701731EUR2E0000073337DA129082300   REFPENNYLANE B13A93908C36C82DF5C319/1                                      ',
          detail_code: 'REF',
          detail: 'PENNYLANE B13A93908C36C82DF5C319/1                                      ',
        )
      end

      it 'adds the reference information' do
        operation.merge_detail(detail)

        expect(operation.reference).to eq('42 - PENNYLANE B13A93908C36C82DF5C319/1')
      end
    end

    context 'with a FEE detail' do
      let(:detail) do
        OpenStruct.new(
          body: '0530004411001871EUR2 0001016255614090823     FEEEUR200000000000740',
          detail_code: 'FEE',
          detail: 'EUR200000000000740',
        )
      end

      it 'adds the fee information' do
        operation.merge_detail(detail)

        expect(operation.fee_currency).to eq('EUR')
        expect(operation.fee).to eq(7.4)
      end
    end
  end

  describe '#type_code' do
    context 'with positive amount' do
      let(:line) { OpenStruct.new(amount: -15, interbank_operation_code: '15', label: 'a label') }

      it 'returns a debit transaction type code' do
        expect(operation.type_code).to eq('15D')
      end
    end

    context 'with negative amount' do
      let(:line) { OpenStruct.new(amount: 15, interbank_operation_code: '2B', label: 'a label') }

      it 'returns a credit transaction type code' do
        expect(operation.type_code).to eq('2BC')
      end
    end
  end
end
