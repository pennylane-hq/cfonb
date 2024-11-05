# frozen_string_literal: true

require 'date'

require_relative 'cfonb/refinements/strings'

require_relative 'cfonb/error'
require_relative 'cfonb/parser'
require_relative 'cfonb/statement'
require_relative 'cfonb/operation'
require_relative 'cfonb/operation_details'

require_relative 'cfonb/line_parser'
require_relative 'cfonb/line_parser/base'
require_relative 'cfonb/line_parser/previous_balance'
require_relative 'cfonb/line_parser/operation'
require_relative 'cfonb/line_parser/operation_details'
require_relative 'cfonb/line_parser/new_balance'

require_relative 'cfonb/operation_details/base'
require_relative 'cfonb/operation_details/lib'
require_relative 'cfonb/operation_details/lcc'
require_relative 'cfonb/operation_details/lc2'
require_relative 'cfonb/operation_details/lcs'
require_relative 'cfonb/operation_details/mmo'
require_relative 'cfonb/operation_details/nbe'
require_relative 'cfonb/operation_details/npy'
require_relative 'cfonb/operation_details/ipy'
require_relative 'cfonb/operation_details/rcn'
require_relative 'cfonb/operation_details/ref'
require_relative 'cfonb/operation_details/fee'
require_relative 'cfonb/operation_details/ibe'
require_relative 'cfonb/operation_details/npo'
require_relative 'cfonb/operation_details/nbu'

module CFONB
  def self.parse(input, optimistic: false)
    Parser.new(input).parse(optimistic: optimistic)
  end

  def self.parse_operation(input, optimistic: false)
    Parser.new(input).parse_operation(optimistic: optimistic)
  end
end
