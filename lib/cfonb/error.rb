# frozen_string_literal: true

module CFONB
  class Error < StandardError; end

  class ParserError < Error; end

  class InvalidCodeError < ParserError; end

  class UnstartedStatementError < ParserError; end

  class UnstartedOperationError < ParserError; end

  class UnfinishedStatementError < ParserError; end

  class AlreadyDefinedOperationError < ParserError; end

  class UnhandledLineCodeError < ParserError; end
end
