# frozen_string_literal: true

require 'cfonb'

describe CFONB::Parser do
  describe '.parse' do
    subject(:statements) { described_class.new(input).parse }

    let(:input) { File.read('spec/files/example.txt') }

    context 'with a valid input' do
      it 'parses correctly' do
        expect(statements).to contain_exactly(
          an_instance_of(CFONB::Statement),
          an_instance_of(CFONB::Statement),
        )

        expect(statements[0]).to have_attributes(
          bank: '15589',
          branch: '00000',
          currency: 'EUR',
          account: '98765432100',
          from: Date.new(2019, 5, 15),
          from_balance: -190.4,
          to: Date.new(2019, 5, 16),
          to_balance: -241.21,
        )

        expect(statements[0].operations.size).to eq(3)

        expect(statements[0].operations[0]).to have_attributes(
          amount: -32.21,
          currency: 'EUR',
          date: Date.new(2019, 5, 16),
          exoneration_code: '0',
          interbank_code: 'B1',
          internal_code: '9162',
          label: "PRLV SEPA TEST CABINET\nMENSUEAUHTR13133",
          number: 0,
          reference: 'REFERENCE - OTHER REFERENCE',
          purpose: 'PURPOSE',
          rejection_code: '',
          unavailability_code: '0',
          value_date: Date.new(2019, 5, 16),
          original_currency: nil,
          original_amount: nil,
          debtor: 'INTERNET SFR',
        )

        expect(statements[0].operations[1]).to have_attributes(
          amount: -10.7,
          currency: 'EUR',
          date: Date.new(2019, 5, 16),
          exoneration_code: '0',
          interbank_code: 'B1',
          internal_code: '9162',
          label: 'VIR  SEPA DEMONSTRATION',
          number: 0,
          reference: 'REFERENCE',
          rejection_code: '',
          unavailability_code: '0',
          value_date: Date.new(2019, 5, 16),
          original_currency: nil,
          original_amount: nil,
          debtor: 'ELEC ERDF',
        )

        expect(statements[0].operations[2]).to have_attributes(
          amount: -7.9,
          currency: 'EUR',
          date: Date.new(2019, 5, 15),
          exoneration_code: '1',
          interbank_code: '62',
          internal_code: '0117',
          label: 'F COMMISSION D INTERVENTION',
          number: 0,
          reference: '',
          rejection_code: '',
          unavailability_code: '0',
          value_date: Date.new(2019, 5, 15),
          original_currency: nil,
          original_amount: nil,
        )

        expect(statements[1]).to have_attributes(
          bank: '18706',
          branch: '00000',
          currency: 'EUR',
          account: '00123456789',
          from: Date.new(2019, 5, 16),
          from_balance: -241.21,
          to: Date.new(2019, 5, 17),
          to_balance: -163.72,
        )

        expect(statements[1].operations.size).to eq(3)

        expect(statements[1].operations[0]).to have_attributes(
          amount: BigDecimal('97.49', 4),
          currency: 'EUR',
          date: Date.new(2019, 5, 17),
          exoneration_code: '',
          interbank_code: 'A3',
          internal_code: '0158',
          label: "PRLV SEPA GROUPAMA CEN\nP051928612   22793301700040",
          number: 0,
          reference: '',
          rejection_code: '',
          unavailability_code: '0',
          value_date: Date.new(2019, 5, 15),
          original_currency: nil,
          original_amount: nil,
        )

        expect(statements[1].operations[1]).to have_attributes(
          amount: -12.1,
          currency: 'EUR',
          date: Date.new(2019, 5, 15),
          exoneration_code: '1',
          interbank_code: '62',
          internal_code: '0337',
          label: 'F FRAIS PRLV IMP 97 49EUR',
          number: 0,
          reference: '',
          rejection_code: '',
          unavailability_code: '0',
          value_date: Date.new(2019, 5, 15),
          original_currency: nil,
          original_amount: nil,
        )

        expect(statements[1].operations[2]).to have_attributes(
          amount: -7.9,
          currency: 'EUR',
          date: Date.new(2019, 5, 16),
          exoneration_code: '1',
          interbank_code: '62',
          internal_code: '0117',
          label: 'F COMMISSION D INTERVENTION',
          number: 0,
          reference: '',
          rejection_code: '',
          unavailability_code: '0',
          value_date: Date.new(2019, 5, 16),
          original_currency: nil,
          original_amount: nil,
        )
      end
    end

    context 'with an operation out of a statement' do
      let(:input) { File.read('spec/files/operation_out_of_statement.txt') }

      it 'raises UnstartedStatementError' do
        expect do
          statements
        end.to raise_error(CFONB::UnstartedStatementError)
      end
    end

    context 'with an operation detail without an operation' do
      let(:input) { File.read('spec/files/operation_detail_without_operation.txt') }

      it 'raises UnstartedOperationError' do
        expect do
          statements
        end.to raise_error(CFONB::UnstartedOperationError)
      end
    end

    context 'with an end of statement without its beginning' do
      let(:input) { File.read('spec/files/end_of_statement_without_beginning.txt') }

      it 'raises UnstartedStatementError' do
        expect do
          statements
        end.to raise_error(CFONB::UnstartedStatementError)
      end
    end

    context 'with a new statement starting without the previous being finished' do
      let(:input) { File.read('spec/files/new_statement_without_previous_ended.txt') }

      it 'raises UnfinishedStatementError' do
        expect do
          statements
        end.to raise_error(CFONB::UnfinishedStatementError)
      end
    end

    context 'when parser error' do
      let(:input) { File.read('spec/files/invalid_date.txt') }

      it 'raises CFONB::ParserError' do
        expect { statements }.to raise_error(CFONB::ParserError)
      end
    end

    context 'with an optimistic parse' do
      subject(:statements) { described_class.new(input).parse(optimistic: true) }

      context 'with a valid input' do
        it 'parses correctly' do
          expect(statements).to contain_exactly(
            an_instance_of(CFONB::Statement),
            an_instance_of(CFONB::Statement),
          )

          expect(statements[0]).to have_attributes(
            bank: '15589',
            branch: '00000',
            currency: 'EUR',
            account: '98765432100',
            from: Date.new(2019, 5, 15),
            from_balance: -190.4,
            to: Date.new(2019, 5, 16),
            to_balance: -241.21,
          )

          expect(statements[0].operations.size).to eq(3)

          expect(statements[0].operations[0]).to have_attributes(
            amount: -32.21,
            currency: 'EUR',
            date: Date.new(2019, 5, 16),
            exoneration_code: '0',
            interbank_code: 'B1',
            internal_code: '9162',
            label: "PRLV SEPA TEST CABINET\nMENSUEAUHTR13133",
            number: 0,
            reference: 'REFERENCE - OTHER REFERENCE',
            rejection_code: '',
            unavailability_code: '0',
            value_date: Date.new(2019, 5, 16),
            original_currency: nil,
            original_amount: nil,
            debtor: 'INTERNET SFR',
          )

          expect(statements[0].operations[1]).to have_attributes(
            amount: -10.7,
            currency: 'EUR',
            date: Date.new(2019, 5, 16),
            exoneration_code: '0',
            interbank_code: 'B1',
            internal_code: '9162',
            label: 'VIR  SEPA DEMONSTRATION',
            number: 0,
            reference: 'REFERENCE',
            rejection_code: '',
            unavailability_code: '0',
            value_date: Date.new(2019, 5, 16),
            original_currency: nil,
            original_amount: nil,
            debtor: 'ELEC ERDF',
          )

          expect(statements[0].operations[2]).to have_attributes(
            amount: -7.9,
            currency: 'EUR',
            date: Date.new(2019, 5, 15),
            exoneration_code: '1',
            interbank_code: '62',
            internal_code: '0117',
            label: 'F COMMISSION D INTERVENTION',
            number: 0,
            reference: '',
            rejection_code: '',
            unavailability_code: '0',
            value_date: Date.new(2019, 5, 15),
            original_currency: nil,
            original_amount: nil,
          )

          expect(statements[1]).to have_attributes(
            bank: '18706',
            branch: '00000',
            currency: 'EUR',
            account: '00123456789',
            from: Date.new(2019, 5, 16),
            from_balance: -241.21,
            to: Date.new(2019, 5, 17),
            to_balance: -163.72,
          )

          expect(statements[1].operations.size).to eq(3)

          expect(statements[1].operations[0]).to have_attributes(
            amount: BigDecimal('97.49', 4),
            currency: 'EUR',
            date: Date.new(2019, 5, 17),
            exoneration_code: '',
            interbank_code: 'A3',
            internal_code: '0158',
            label: "PRLV SEPA GROUPAMA CEN\nP051928612   22793301700040",
            number: 0,
            reference: '',
            rejection_code: '',
            unavailability_code: '0',
            value_date: Date.new(2019, 5, 15),
            original_currency: nil,
            original_amount: nil,
          )

          expect(statements[1].operations[1]).to have_attributes(
            amount: -12.1,
            currency: 'EUR',
            date: Date.new(2019, 5, 15),
            exoneration_code: '1',
            interbank_code: '62',
            internal_code: '0337',
            label: 'F FRAIS PRLV IMP 97 49EUR',
            number: 0,
            reference: '',
            rejection_code: '',
            unavailability_code: '0',
            value_date: Date.new(2019, 5, 15),
            original_currency: nil,
            original_amount: nil,
          )

          expect(statements[1].operations[2]).to have_attributes(
            amount: -7.9,
            currency: 'EUR',
            date: Date.new(2019, 5, 16),
            exoneration_code: '1',
            interbank_code: '62',
            internal_code: '0117',
            label: 'F COMMISSION D INTERVENTION',
            number: 0,
            reference: '',
            rejection_code: '',
            unavailability_code: '0',
            value_date: Date.new(2019, 5, 16),
            original_currency: nil,
            original_amount: nil,
          )
        end
      end

      context 'with an operation out of a statement' do
        let(:input) { File.read('spec/files/operation_out_of_statement.txt') }

        it 'ignores the operation' do
          expect(statements.size).to eq(1)
          expect(statements[0].operations.size).to eq(1)
          expect(statements[0].operations[0]).to have_attributes(
            amount: -10.7,
            currency: 'EUR',
            date: Date.new(2019, 5, 16),
            exoneration_code: '0',
            interbank_code: 'B1',
            internal_code: '9162',
            label: 'VIR  SEPA DEMONSTRATION',
            number: 0,
            reference: '',
            rejection_code: '',
            unavailability_code: '0',
            value_date: Date.new(2019, 5, 16),
            original_currency: nil,
            original_amount: nil,
            debtor: 'ELEC ERDF',
          )
        end
      end

      context 'with an operation detail without an operation' do
        let(:input) { File.read('spec/files/operation_detail_without_operation.txt') }

        it 'ignores the operation detail' do
          expect(statements.size).to eq(1)
          expect(statements[0].operations.size).to eq(1)
          expect(statements[0].operations[0]).to have_attributes(
            amount: -10.7,
            currency: 'EUR',
            date: Date.new(2019, 5, 16),
            exoneration_code: '0',
            interbank_code: 'B1',
            internal_code: '9162',
            label: 'VIR  SEPA DEMONSTRATION',
            number: 0,
            reference: '',
            rejection_code: '',
            unavailability_code: '0',
            value_date: Date.new(2019, 5, 16),
            original_currency: nil,
            original_amount: nil,
            debtor: 'ELEC ERDF',
          )
        end
      end

      context 'with an end of statement without its beginning' do
        let(:input) { File.read('spec/files/end_of_statement_without_beginning.txt') }

        it 'ignores the end of statement' do
          expect(statements.size).to eq(1)
          expect(statements[0].operations.size).to eq(1)
          expect(statements[0].operations[0]).to have_attributes(
            amount: -10.7,
            currency: 'EUR',
            date: Date.new(2019, 5, 16),
            exoneration_code: '0',
            interbank_code: 'B1',
            internal_code: '9162',
            label: 'VIR  SEPA DEMONSTRATION',
            number: 0,
            reference: '',
            rejection_code: '',
            unavailability_code: '0',
            value_date: Date.new(2019, 5, 16),
            original_currency: nil,
            original_amount: nil,
            debtor: 'ELEC ERDF',
          )
        end
      end

      context 'with a new statement starting without the previous being finished' do
        let(:input) { File.read('spec/files/new_statement_without_previous_ended.txt') }

        it 'ignores the new statement' do
          expect(statements.size).to eq(1)
          expect(statements[0].operations.size).to eq(2)
          expect(statements[0].operations[0]).to have_attributes(
            amount: -10.7,
            currency: 'EUR',
            date: Date.new(2019, 5, 16),
            exoneration_code: '0',
            interbank_code: 'B1',
            internal_code: '9162',
            label: 'VIR  SEPA DEMONSTRATION',
            number: 0,
            reference: '',
            rejection_code: '',
            unavailability_code: '0',
            value_date: Date.new(2019, 5, 16),
            original_currency: nil,
            original_amount: nil,
            debtor: 'ELEC ERDF',
          )
          expect(statements[0].operations[1]).to have_attributes(
            amount: -7.9,
            currency: 'EUR',
            date: Date.new(2019, 5, 16),
            exoneration_code: '1',
            interbank_code: '62',
            internal_code: '0117',
            label: 'F COMMISSION D INTERVENTION',
            number: 0,
            reference: '',
            rejection_code: '',
            unavailability_code: '0',
            value_date: Date.new(2019, 5, 16),
            original_currency: nil,
            original_amount: nil,
          )
        end
      end

      context 'when parser error' do
        let(:input) { File.read('spec/files/invalid_date.txt') }

        it 'returns empty statements' do
          expect(statements.size).to eq(0)
        end
      end
    end
  end

  describe '.parse_operation' do
    subject(:operation) { described_class.new(input).parse_operation }

    let(:input) { File.read('spec/files/operation.txt') }

    context 'with a valid input' do
      it 'returns CFONB::Operation' do
        expect(operation).to be_an_instance_of(CFONB::Operation)
      end

      it 'parses correctly' do
        expect(operation).to have_attributes(
          amount: -32.21,
          currency: 'EUR',
          date: Date.new(2019, 5, 16),
          exoneration_code: '0',
          interbank_code: 'B1',
          internal_code: '9162',
          label: "PRLV SEPA TEST CABINET\nMENSUEAUHTR13133",
          number: 0,
          reference: 'REFERENCE - OTHER REFERENCE',
          rejection_code: '',
          unavailability_code: '0',
          value_date: Date.new(2019, 5, 16),
          original_currency: nil,
          original_amount: nil,
          debtor: 'INTERNET SFR',
        )
      end
    end

    context 'with an already defined operation' do
      let(:input) { File.read('spec/files/operation_already_defined.txt') }

      it 'raises AlreadyDefinedOperationError' do
        expect do
          operation
        end.to raise_error(CFONB::AlreadyDefinedOperationError)
      end
    end

    context 'with an unstarted operation' do
      let(:input) { File.read('spec/files/operation_unstarted.txt') }

      it 'raises UnstartedOperationError' do
        expect do
          operation
        end.to raise_error(CFONB::UnstartedOperationError)
      end
    end

    context 'with an unhandled line code' do
      let(:input) { File.read('spec/files/example.txt') }

      it 'raises UnhandledLineCodeError' do
        expect do
          operation
        end.to raise_error(CFONB::UnhandledLineCodeError)
      end
    end

    context 'with an optimistic parse' do
      subject(:operation) { described_class.new(input).parse_operation(optimistic: true) }

      context 'with a valid input' do
        it 'returns CFONB::Operation' do
          expect(operation).to be_an_instance_of(CFONB::Operation)
        end

        it 'parses correctly' do
          expect(operation).to have_attributes(
            amount: -32.21,
            currency: 'EUR',
            date: Date.new(2019, 5, 16),
            exoneration_code: '0',
            interbank_code: 'B1',
            internal_code: '9162',
            label: "PRLV SEPA TEST CABINET\nMENSUEAUHTR13133",
            number: 0,
            reference: 'REFERENCE - OTHER REFERENCE',
            rejection_code: '',
            unavailability_code: '0',
            value_date: Date.new(2019, 5, 16),
            original_currency: nil,
            original_amount: nil,
            debtor: 'INTERNET SFR',
          )
        end
      end

      context 'with an already defined operation' do
        let(:input) { File.read('spec/files/operation_already_defined.txt') }

        it 'ignores the second operation' do
          expect(operation).to have_attributes(
            amount: -32.21,
            currency: 'EUR',
            date: Date.new(2019, 5, 16),
            exoneration_code: '0',
            interbank_code: 'B1',
            internal_code: '9162',
            label: "PRLV SEPA TEST CABINET\nMENSUEAUHTR13133",
            number: 0,
            reference: 'REFERENCE - OTHER REFERENCE',
            rejection_code: '',
            unavailability_code: '0',
            value_date: Date.new(2019, 5, 16),
            original_currency: nil,
            original_amount: nil,
            debtor: 'INTERNET SFR',
          )
        end
      end

      context 'with an unstarted operation' do
        let(:input) { File.read('spec/files/operation_unstarted.txt') }

        it 'returns no operation' do
          expect(operation).to be_nil
        end
      end

      context 'with an unhandled line code' do
        let(:input) { File.read('spec/files/example.txt') }

        it 'ignores the unhandled lines' do
          expect(operation).to have_attributes(
            amount: -32.21,
            currency: 'EUR',
            date: Date.new(2019, 5, 16),
            exoneration_code: '0',
            interbank_code: 'B1',
            internal_code: '9162',
            label: "PRLV SEPA TEST CABINET\nMENSUEAUHTR13133\nP051928612   22793301700040",
            number: 0,
            reference: 'REFERENCE - OTHER REFERENCE',
            rejection_code: '',
            unavailability_code: '0',
            value_date: Date.new(2019, 5, 16),
            original_currency: nil,
            original_amount: nil,
            debtor: 'ELEC ERDF',
          )
        end
      end
    end
  end
end
