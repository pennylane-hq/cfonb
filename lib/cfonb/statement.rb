# frozen_string_literal: true

module CFONB
  class Statement
    attr_accessor(
      *%i[
        begin_raw end_raw
        bank branch currency account
        from from_balance
        to to_balance
        operations
      ]
    )

    def initialize(line)
      self.begin_raw = line.body
      self.bank = line.bank
      self.branch = line.branch
      self.currency = line.currency
      self.account = line.account
      self.from = line.date
      self.from_balance = line.amount
      self.operations = []
    end

    def merge_new_balance(line)
      self.end_raw = line.body
      self.to = line.date
      self.to_balance = line.amount
    end

    def raw
      [
        begin_raw,
        operations.map(&:raw),
        end_raw
      ].join("\n")
    end

    def rib
      # https://fr.wikipedia.org/wiki/Clé_RIB
      key = 97 - ((
        (bank.to_i * 89) +
        (branch.to_i * 15) +
        (account.upcase.tr('A-IJ-RS-Z', '1-91-92-9').to_i * 3)
      ) % 97)

      "#{bank}#{branch}#{account}#{key.to_s.rjust(2, '0')}"
    end

    def iban
      # https://fr.wikipedia.org/wiki/International_Bank_Account_Number
      normalized_rib = "#{rib}FR00".upcase.gsub(/[A-Z]/) { _1.ord - 55 }
      key = 98 - (normalized_rib.to_i % 97)

      "FR#{key.to_s.rjust(2, '0')}#{rib}"
    end
  end
end
