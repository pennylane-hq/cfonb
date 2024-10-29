# frozen_string_literal: true

require 'date'

require_relative 'cfonb/refinements/strings'

require_relative 'cfonb/error'
require_relative 'cfonb/parser'
require_relative 'cfonb/statement'
require_relative 'cfonb/operation'
require_relative 'cfonb/operation_detail'

require_relative 'cfonb/line_parser'
require_relative 'cfonb/line_parser/base'
require_relative 'cfonb/line_parser/previous_balance'
require_relative 'cfonb/line_parser/operation'
require_relative 'cfonb/line_parser/operation_detail'
require_relative 'cfonb/line_parser/new_balance'

require_relative 'cfonb/operation_detail/lib'
require_relative 'cfonb/operation_detail/lcc'
require_relative 'cfonb/operation_detail/lc2'
require_relative 'cfonb/operation_detail/lcs'
require_relative 'cfonb/operation_detail/mmo'
require_relative 'cfonb/operation_detail/nbe'
require_relative 'cfonb/operation_detail/npy'
require_relative 'cfonb/operation_detail/ipy'
require_relative 'cfonb/operation_detail/rcn'
require_relative 'cfonb/operation_detail/ref'
require_relative 'cfonb/operation_detail/fee'
require_relative 'cfonb/operation_detail/ibe'
require_relative 'cfonb/operation_detail/npo'
require_relative 'cfonb/operation_detail/nbu'

module CFONB
  def self.parse(input, optimistic: false)
    Parser.new(input).parse(optimistic: optimistic)
  end

  def self.parse_operation(input, optimistic: false)
    Parser.new(input).parse_operation(optimistic: optimistic)
  end
end
