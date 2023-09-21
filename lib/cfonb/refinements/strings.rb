# frozen_string_literal: true

module CFONB
  module Refinements
    module Strings
      refine String do

        def first(count = 1)
          self[..(count - 1)]
        end

        def last(count = 1)
          self[-count..]
        end
      end
    end
  end
end
